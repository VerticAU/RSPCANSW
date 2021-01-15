public class AnnualReceiptMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.init();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private Map<String, List<SObject>> donationsByContactIdsMap;
    private Map<String, String> accountIdOneToOneContactIdMap;
    private Map<Id, Contact> contactsMap;

    private Date startDate;
    private Date endDate;

    private void init() {

        String donorIdsStr = this.request.getRequiredString('donorIds');

        this.startDate = this.request.getISODate('startDate');
        this.endDate = this.request.getISODate('endDate');

        String renderAs = this.request.getString('renderAs');

        List<String> donorIds = donorIdsStr.split(',');

        List<Contact> contacts = this.retrieveContacts(donorIds);
        this.contactsMap = new Map<Id, Contact>(contacts);

        List<Opportunity> contactDonations = this.retrieveContactDonations(donorIds, this.startDate, this.endDate);
        List<Opportunity> accountDonations = this.retrieveAccountDonations(donorIds, this.startDate, this.endDate);
        this.donationsByContactIdsMap = vertic_Utils.sObjects.getSObjectsListByAnyFieldMap(contactDonations, Opportunity.npsp__Primary_Contact__c);

        // add Organisation donations and map to one-to-one Contacts
        this.accountIdOneToOneContactIdMap = new Map<String, String>();
        for(Opportunity donation : accountDonations){
            String oneToOneContactId = donation.Account.npe01__One2OneContact__c;
            this.accountIdOneToOneContactIdMap.put(donation.AccountId, donation.Account.npe01__One2OneContact__c);
            if(this.donationsByContactIdsMap.containsKey(oneToOneContactId)){
                this.donationsByContactIdsMap.get(oneToOneContactId).add(donation);
            } else {
                this.donationsByContactIdsMap.put(oneToOneContactId, new List<Opportunity>{ donation });
            }
        }
        this.contactsMap.putAll(new Map<Id, Contact>(this.retrieveContacts(this.accountIdOneToOneContactIdMap.values())));

        List<Object> components = new List<Object>();

        for (String donorId : donorIds) {
            Contact contactVar;
            List<Opportunity> donorDonations;
            if(Id.valueOf(donorId).getSobjectType() == Account.SObjectType){
                contactVar = this.contactsMap.get(this.accountIdOneToOneContactIdMap.get(donorId));
                vertic_Utils.objects.throwIfBlank(contactVar, 'No Contact for Account Id: ' + donorId);
            } else {
                contactVar = this.contactsMap.get(donorId);
                vertic_Utils.objects.throwIfBlank(contactVar, 'No Contact with Id: ' + donorId);
            }

            donorDonations = this.donationsByContactIdsMap.get(contactVar.Id);
            donorDonations = donorDonations == null ? new List<Opportunity>() : donorDonations;

            Decimal totalAmount = 0;
            for (Opportunity donationVar : donorDonations) {
                totalAmount += vertic_Utils.objects.defaultIfNull(donationVar.Amount, 0);
            }

            Datetime startTaxDate = Datetime.newInstance(this.startDate, Time.newInstance(0,0,0,0));
            Datetime endTaxDate = Datetime.newInstance(this.endDate, Time.newInstance(0,0,0,0));

            vertic_DTO dto = new vertic_DTO();
            new vertic_AutoMapper(dto)
                .getOptions()
                .setIsVisualforce(true)
                .setIsAllFields(true)
                .setDefaultFieldValue(' ')
                .getMapper()
                .mapAnyValue('taxPeriod', startTaxDate.format('d MMM YYYY') + ' - ' + endTaxDate.format('d MMM YYYY'))
                .mapAnyValue('donationAmount', totalAmount)
                .mapFromListSObjects('donations', donorDonations)
                .mapAnyValue('donor.FirstName', contactVar.FirstName)
                .mapAnyValue('donor.Name', contactVar.Name)
                .mapAnyValue('hasDonations', donorDonations.isEmpty() == false)
                .mapAnyValue('isCopy', false);

            if('html'.equalsIgnoreCase(renderAs)){
                components.add(new Component.DefaultAnnualReceipt(dto = dto.getMap()));
            }
        }

        if (components.isEmpty()) { components.add(new Component.Apex.OutputText(value = 'No Donations')); }

        this.response.dto.put('components', components);
        this.response.dto.put('head-component', new Component.DefaultAnnualReceiptStyles());
        this.response.dto.put('custom-styles', 'p{margin:0;}');
        this.response.dto.put('font-family', 'Times');

        this.setFileName();
    }

    private void setFileName(){
        if(ApexPages.currentPage() != null){
            ApexPages.currentPage()
                .getHeaders()
                .put('content-disposition', 'filename=' + ContributionService.formatAnnualReceiptFileName(this.startDate, this.endDate));
        }
    }

    private List<Opportunity> retrieveContactDonations(List<String> recordIds, Date startDate, Date endDate){
        return [
            SELECT Id,
                npe03__Recurring_Donation__c,
                npsp__Primary_Contact__c,
                Name, Amount, CloseDate,
                Payment_Method__c,
                CampaignId,
                Campaign.Name
            FROM Opportunity
            WHERE npsp__Primary_Contact__c IN :recordIds
            AND CloseDate >= :startDate
            AND CloseDate <= :endDate
            AND StageName = 'Closed Won'
            AND Amount >= 0
            ORDER BY Name, CloseDate ASC
        ];
    }

    private List<Opportunity> retrieveAccountDonations(List<String> recordIds, Date startDate, Date endDate){
        return [
            SELECT Id,
                npe03__Recurring_Donation__c,
                Account.npe01__One2OneContact__c,
                Account.npe01__One2OneContact__r.Name,
                Name, Amount, CloseDate,
                Payment_Method__c,
                CampaignId,
                Campaign.Name
            FROM Opportunity
            WHERE AccountId IN :recordIds
            AND CloseDate >= :startDate
            AND CloseDate <= :endDate
            AND StageName = 'Closed Won'
            AND Amount >= 0
            AND Account.npe01__One2OneContact__c != NULL
            ORDER BY Name, CloseDate ASC
        ];
    }
    private List<Contact> retrieveContacts(List<String> recordIds){
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(this.getContactFields());

        queryFactory.setCondition('Id IN :recordIds');
        List<Contact> contacts = (List<Contact>) Database.query(queryFactory.toSOQL());

        return contacts;
    }

    private List<String> getContactFields(){

        List<String> fields = new List<String>{
            'Salutation',
            'FirstName',
            'LastName',
            'Name',
            'Email'
        };

        fields.addAll(this.getFormulaFields(Contact.SObjectType, null));
        return fields;
    }

    private Set<String> getFormulaFields(SObjectType sObjType, String prefix) {
        Set<String> additionalFields = new Set<String>();
        Map<String, SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        for (String fieldToken : fieldsMap.keySet()) {
            SObjectField sObjectFieldVar = fieldsMap.get(fieldToken);
            DescribeFieldResult fieldVarDescribe = sObjectFieldVar.getDescribe();
            if (fieldVarDescribe.isCalculated()) {
                additionalFields.add((String.isNotBlank(prefix) ? prefix : '') + fieldVarDescribe.getName());
            }
        }
        return additionalFields;
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_meta_request
    // vertic_meta_response

}