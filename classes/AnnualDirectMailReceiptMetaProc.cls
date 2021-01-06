public class AnnualDirectMailReceiptMetaProc extends vertic_TemplateMetaProc {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Map<String, List<SObject>> donationsByContactIdsMap;
    private Map<String, Decimal> totalAmountByContactIdsMap;
    private Map<Id, Contact> contactsMap;

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
        List<String> recordIds = this.getIds();

        this.startDate = this.request.getISODate('startDate');
        this.endDate = this.request.getISODate('endDate');

        if(this.startDate == null){ this.startDate = Date.today(); }
        if(this.endDate == null){ this.endDate = Date.today(); }

        this.contactsMap = new Map<Id, Contact>(this.retrieveContacts(recordIds));

        List<Opportunity> donations = this.retrieveDonations(recordIds, this.startDate, this.endDate);
        this.donationsByContactIdsMap = vertic_Utils.sObjects.getSObjectsListByAnyFieldMap(donations, Opportunity.npsp__Primary_Contact__c);

        this.totalAmountByContactIdsMap = new Map<String, Decimal>();
    }

    private List<Contact> retrieveContacts(List<String> recordIds){
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(this.getFields());
        queryFactory.setCondition('Id IN :recordIds');
        return (List<Contact>) Database.query(queryFactory.toSOQL());
    }

    private List<Opportunity> retrieveDonations(List<String> recordIds, Date startDate, Date endDate){
        return [
            SELECT Id, npe03__Recurring_Donation__c, npsp__Primary_Contact__c,
                Name, Amount, CloseDate, Payment_Method__c, CampaignId, Campaign.Name
            FROM Opportunity
            WHERE npsp__Primary_Contact__c IN :recordIds
            AND CloseDate >= :startDate
            AND CloseDate <= :endDate
            AND StageName = 'Closed Won'
            AND Amount >= 0
            ORDER BY Name, CloseDate ASC
        ];
    }

    protected override void initMetadata(String componentId, vertic_DTO dto) {

        Contact contactVar = this.contactsMap.get(componentId);
        vertic_Utils.objects.throwIfBlank(contactVar, 'No Contact with Id: ' + componentId);

        List<Opportunity> contactDonations = donationsByContactIdsMap.get(contactVar.Id);
        contactDonations = contactDonations == null ? new List<Opportunity>() : contactDonations;
        Decimal totalAmount = 0;
        for (Opportunity donationVar : contactDonations) {
            totalAmount += vertic_Utils.objects.defaultIfNull(donationVar.Amount, 0);
        }

        this.totalAmountByContactIdsMap.put(componentId, totalAmount);

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

        Contact contactVar = this.contactsMap.get(componentId);
        if(contactVar == null) { return null; }

        System.debug('componentId ' + componentId);
        System.debug('donationsByContactIdsMap ' + this.donationsByContactIdsMap);

        List<Opportunity> donations = this.donationsByContactIdsMap.get(componentId);
        if(donations == null || donations.size() == 0){ return null; }

        Opportunity donation = (Opportunity) donations[0];
        if(donation == null){ return null; }

        Decimal totalAmount = this.totalAmountByContactIdsMap.get(componentId);

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

        if(template == null){ return null; }

        dto.put('imageUrl', template.Header_Image__c);

        return template.Receipt_Body_Text__c;
    }

    protected override ApexPages.Component getComponentInstance(String name, vertic_DTO dto) {
        if ('DirectMailReceiptTable'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptTable(dto = dto.getMap());
        } else if ('DirectMailReceiptImage'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptImage(dto = dto.getMap());
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