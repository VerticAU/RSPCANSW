public class AnnualDirectMailReceiptMetaProc extends vertic_TemplateMetaProc {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Map<String, List<SObject>> donationsByContactIdsMap;
    private Map<String, Decimal> totalAmountByContactIdsMap;

    private Map<Id, Contact> contactsMap;
    private Map<String, String> accountIdOneToOneContactIdMap;

    private Date startDate;
    private Date endDate;

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        super.process(request);

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             OVERRIDES
     * ==============================================================================================================
     */

    protected override void beforeProcess() {
        this.startDate = this.request.getISODate('startDate');
        this.endDate = this.request.getISODate('endDate');

        if(this.startDate == null){ this.startDate = Date.today(); }
        if(this.endDate == null){ this.endDate = Date.today(); }

        List<String> recordIds = this.getIds();

        this.contactsMap = new Map<Id, Contact>(this.retrieveContacts(recordIds));

        List<Opportunity> contactDonations = this.retrieveContactDonations(recordIds, this.startDate, this.endDate);
        List<Opportunity> accountDonations = this.retrieveAccountDonations(recordIds, this.startDate, this.endDate);

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
        this.totalAmountByContactIdsMap = new Map<String, Decimal>();
    }

    private List<Contact> retrieveContacts(List<String> recordIds){
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(this.getFields());
        queryFactory.setCondition('Id IN :recordIds');
        return (List<Contact>) Database.query(queryFactory.toSOQL());
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

    private Contact getContactByComponentId(String componentId){
        if(Id.valueOf(componentId).getSobjectType() == Account.SObjectType){
            return this.contactsMap.get(this.accountIdOneToOneContactIdMap.get(componentId));
        } else {
            return this.contactsMap.get(componentId);
        }
    }

    protected override void initMetadata(String componentId, vertic_DTO dto) {

        Contact contactVar = getContactByComponentId(componentId);
        vertic_Utils.objects.throwIfBlank(contactVar, 'No Contact for componentId: ' + componentId);

        List<Opportunity> contactDonations = this.donationsByContactIdsMap.get(contactVar.Id);
        contactDonations = contactDonations == null ? new List<Opportunity>() : contactDonations;

        Decimal totalAmount = 0;
        for (Opportunity donationVar : contactDonations) {
            totalAmount += vertic_Utils.objects.defaultIfNull(donationVar.Amount, 0);
        }

        this.totalAmountByContactIdsMap.put(contactVar.Id, totalAmount);

        List<String> args = new String[]{'0','number','###,###,##0.00'};
        String formattedAmount = String.format(totalAmount.format(), args);

        new vertic_AutoMapper(dto)
            .getOptions()
            .setIsVisualforce(true)
            .setIsAllFields(true)
            .setDefaultFieldValue(' ')
            .getMapper()
            .mapAnyValue('currentYear', Date.today().year())
            .mapAnyValue('today', Date.today().format())
            .mapFromListSObjects('donations', contactDonations)
            .mapFromSObject('recipient', contactVar)
            .mapFromSObject('organisation', contactVar.Account != null ? contactVar.Account : new Account())
            .mapAnyValue('startDate', this.startDate.format())
            .mapAnyValue('endDate', this.endDate.format())
            .mapAnyValue('totalAmount', totalAmount)
            .mapAnyValue('totalAmountFormatted', formattedAmount)
            .mapAnyValue('hasDonations', contactDonations.isEmpty() == false);
    }

    protected override void afterProcess() {
        List<Object> components = this.response.getList('components');
        if (components.isEmpty()) {
            components.add(new Component.Apex.OutputText(value = 'No Contacts'));
        }
        this.response.dto.put('components', components);
        this.response.dto.put('head-component', new Component.DefaultAnnualReceiptStyles());

        this.setFileName();

        if (this.request.getBoolean('afterProc') == true) {
            this.doAfterProc(String.join(this.getIds(), ','));
        }
    }

    protected override String getTemplate(String componentId, vertic_DTO dto) {

        Contact contactVar = getContactByComponentId(componentId);
        if(contactVar == null) { return '<p>Contact is not found.<\\p><p>Component Id: ' + componentId + '<\\p>'; }

        List<Opportunity> donations = this.donationsByContactIdsMap.get(contactVar.Id);
        if(donations == null || donations.size() == 0){ return '<p>Donations are not found.<\\p><p>Contact: ' + contactVar.Id + '<\\p>'; }

        Opportunity donation = (Opportunity) donations[0];
        if(donation == null){ return '<p>Donations are not found.<\\p><p>Contact: ' + contactVar.Id + '<\\p>'; }

        Decimal totalAmount = this.totalAmountByContactIdsMap.get(contactVar.Id);

        Direct_Mail_Receipt_Template__c template = (Direct_Mail_Receipt_Template__c)vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                Envelope_Type__c,
                Header_Image__c,
                Receipt_Body_Text__c
            FROM Direct_Mail_Receipt_Template__c
            WHERE Campaign__c =: donation.CampaignId
            AND Minimum_Donation__c <: totalAmount
            AND Maximum_Donation__c >: totalAmount
        ]);

        if(template == null){
            return '<p>Template is no found.<\\p>' +
            '<p>Contact: ' + contactVar.Id + '<\\p>' +
            '<p>Campaign: ' + donation.CampaignId + '<\\p>' +
            '<p>Total Amount: $' + totalAmount + '<\\p>';
        }
        dto.put('imageUrl', template.Header_Image__c);

        return template.Receipt_Body_Text__c;
    }

    protected override ApexPages.Component getComponentInstance(String name, vertic_DTO dto) {
        String envelopeType = vertic_Utils.strings.defaultIfBlank(dto.getString('envelopeType'), 'DLX');
        if ('DirectMailReceiptTable'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptTable(dto = dto.getMap());
        } else if ('DirectMailReceiptImage'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptImage(dto = dto.getMap());
        } else if ('DirectMailReceiptAddress'.equalsIgnoreCase(name) && envelopeType == 'DLX') {
            return new Component.DirectMailReceiptAddressDLX(dto = dto.getMap());
        } else if ('DirectMailReceiptAddress'.equalsIgnoreCase(name) && envelopeType == 'C5') {
            return new Component.DirectMailReceiptAddressC5(dto = dto.getMap());
        }
        return null;
    }

    @TestVisible
    private void setFileName(){
        if(ApexPages.currentPage() != null){
            ApexPages.currentPage()
                .getHeaders()
                .put('content-disposition', 'filename=' + ContributionService.formatAnnualReceiptFileName(this.startDate, this.endDate));
        }
    }

    private void doAfterProc(String ids) {
        new AnnualReceiptAfterProc().process(new Map<String, Object> {
            'ids' => ids,
            'startDate' => this.startDate,
            'endDate' => this.endDate
        });
    }

    private List<String> getFields(){

        List<String> fields = new List<String>{
            'Greeting__c',
            'Letter_Salutation__c',
            'Contact_Id__c',
            'Care_Of__c',
            'FirstName',
            'LastName',
            'Name',
            'Salutation',
            'Title',
            'Email',
            'MailingStreet',
            'MailingCity',
            'MailingState',
            'MailingCountry',
            'MailingPostalCode',
            'Account.Name'
        };

        fields.addAll(getFormulaFields(Contact.SObjectType, null));
        return fields;
    }

    public override List<vertic_TemplateMetaProc.MergeFieldsSet> getMergeFieldSets(){
        List<String> fields = this.getFields();

        vertic_TemplateMetaProc.MergeFieldsSet otherMergeFieldsSet = new vertic_TemplateMetaProc.MergeFieldsSet();
        otherMergeFieldsSet.label = 'Other';
        otherMergeFieldsSet.name = 'other';

        otherMergeFieldsSet.items.add(new vertic_TemplateMetaProc.MergeFieldsItem('today', 'Today date'));
        otherMergeFieldsSet.items.add(new vertic_TemplateMetaProc.MergeFieldsItem('totalAmount', 'Total Donation Amount'));
        otherMergeFieldsSet.items.add(new vertic_TemplateMetaProc.MergeFieldsItem('totalAmountFormatted', 'Formatted Total Donation Amount'));
        otherMergeFieldsSet.items.add(new vertic_TemplateMetaProc.MergeFieldsItem('startDate', 'Start Date'));
        otherMergeFieldsSet.items.add(new vertic_TemplateMetaProc.MergeFieldsItem('endDate', 'End Date'));

        return new List<vertic_TemplateMetaProc.MergeFieldsSet>{
            this.getMergeFieldSet(fields, Contact.SObjectType, Contact.SObjectType, 'donor.', null),
            otherMergeFieldsSet
        };
    }

    public override SObjectType getSObjectType() {
        return Contact.SObjectType;
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