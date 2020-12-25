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

    private Boolean isEmailLayout = false;
    private Map<String, List<SObject>> donationsByContactIdsMap;
    private Map<String, List<SObject>> donationsByAccountIdsMap;
    private Map<Id, Contact> contactMap;
    private Map<Id, Account> accountMap;

    private Date startDate;
    private Date endDate;

    private void init() {

        String donorIdsStr = this.request.getRequiredString('donorIds');

        this.startDate = this.request.getISODate('startDate');
        this.endDate = this.request.getISODate('endDate');

        String renderAs = this.request.getString('renderAs');
        this.isEmailLayout = 'html'.equalsIgnoreCase(renderAs);

        List<String> donorIds = donorIdsStr.split(',');

        List<Contact> contacts = this.retrieveContacts(donorIds);
        this.contactMap = new Map<Id, Contact>(contacts);

        List<Account> accounts = this.retrieveAccounts(donorIds);
        this.accountMap = new Map<Id, Account>(accounts);

        List<Opportunity> donations = this.retrieveDonations(donorIds, startDate, endDate);
        this.donationsByContactIdsMap = vertic_Utils.sObjects.getSObjectsListByAnyFieldMap(donations, Opportunity.npsp__Primary_Contact__c);
        this.donationsByAccountIdsMap = vertic_Utils.sObjects.getSObjectsListByAnyFieldMap(donations, Opportunity.AccountId);

        List<Object> components = new List<Object>();

        Decimal donationAmount;
        for (String donorId : donorIds) {

            String donorIdentifier;
            String donorName;
            String donorAddress;

            SObjectType sType = Id.valueOf(donorId).getSobjectType();

            List<Opportunity> donorDonations;
            if(sType == Contact.SObjectType){
                Contact contactVar = this.contactMap.get(donorId);
                vertic_Utils.objects.throwIfBlank(contactVar, 'No Contact with Id: ' + donorId);

                donorName = contactVar.Name;
//                donorAddress = contactVar.Donor_Address__c; todo

                donorDonations = this.donationsByContactIdsMap.get(donorId);
                donorDonations = donorDonations == null ? new List<Opportunity>() : donorDonations;
            } else if(sType == Account.SObjectType){
                Account accountVar = this.accountMap.get(donorId);
                vertic_Utils.objects.throwIfBlank(accountVar, 'No Organisation with Id: ' + donorId);

                donorName = accountVar.Name;
//                donorAddress = accountVar.Donor_Address__c; todo

                donorDonations = this.donationsByAccountIdsMap.get(donorId);
                donorDonations = donorDonations == null ? new List<Opportunity>() : donorDonations;
            }

            donationAmount = 0;
            for (Opportunity donation : donorDonations) {  donationAmount += donation.Amount; }

            String content;
            Boolean useDefaultContent = true;

            Datetime startTaxDate = Datetime.newInstance(startDate, Time.newInstance(0,0,0,0));
            Datetime endTaxDate = Datetime.newInstance(endDate, Time.newInstance(0,0,0,0));

            vertic_DTO dto = new vertic_DTO();
            new vertic_AutoMapper(dto)
                .getOptions()
                .setIsVisualforce(true)
                .setIsAllFields(true)
                .setDefaultFieldValue(' ')
                .getMapper()
                .mapAnyValue('taxPeriod', startTaxDate.format('d MMMM YYYY') + ' and ' + endTaxDate.format('d MMMM YYYY'))
                .mapAnyValue('donationAmount', donationAmount)
                .mapFromListSObjects('donations', donorDonations)
                .mapAnyValue('donor.Identifier', donorIdentifier == null ? '' : donorIdentifier)
                .mapAnyValue('donor.Name', donorName)
                .mapAnyValue('donor.Address', donorAddress)
                .mapAnyValue('useDefaultContent', useDefaultContent)
                .mapAnyValue('receiptContent', content)
                .mapAnyValue('hasDonations', donorDonations.isEmpty() == false)
                .mapAnyValue('isCopy', false);

            if(this.isEmailLayout){
//                components.add(new Component.DefaultAnnualReceiptEmail(dto = dto.getMap())); todo
                components.add(new Component.DefaultAnnualReceipt(dto = dto.getMap()));
            } else {
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

    private List<Opportunity> retrieveDonations(List<String> recordIds, Date startDate, Date endDate){
        return [
            SELECT Id, npe03__Recurring_Donation__c, npsp__Primary_Contact__c,
                Name, Amount, CloseDate, Payment_Method__c, AccountId
            FROM Opportunity
            WHERE Status__c = 'Processed'
            AND CloseDate >= :startDate
            AND CloseDate <= :endDate
            AND Amount >= 0
            AND (
                npsp__Primary_Contact__c IN :recordIds
                OR AccountId IN :recordIds
            )
            ORDER BY Name, CloseDate ASC
        ];
    }

    private List<Account> retrieveAccounts(List<String> recordIds){
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Account.SObjectType);
        queryFactory.selectFields(this.getAccountFields());

        queryFactory.setCondition('Id IN :recordIds');
        List<Account> accounts = (List<Account>) Database.query(queryFactory.toSOQL());

        return accounts;
    }

    private List<Contact> retrieveContacts(List<String> recordIds){
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(this.getContactFields());

        queryFactory.setCondition('Id IN :recordIds');
        List<Contact> contacts = (List<Contact>) Database.query(queryFactory.toSOQL());

        return contacts;
    }

    private List<String> getAccountFields(){

        List<String> fields = new List<String>{
            'Name',
            'BillingStreet',
            'BillingCity',
            'BillingState',
            'BillingPostalCode',
            'Email__c'
//            'Donor_Address__c'
        };

        fields.addAll(this.getFormulaFields(Account.SObjectType, null));
        return fields;
    }

    private List<String> getContactFields(){

        List<String> fields = new List<String>{
            'Salutation',
            'FirstName',
            'LastName',
            'Name',
            'Email',
            'MailingStreet',
            'MailingCity',
            'MailingState',
            'MailingPostalCode'
//            'Donor_Address__c',
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