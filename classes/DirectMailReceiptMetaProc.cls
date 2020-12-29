public without sharing class DirectMailReceiptMetaProc extends vertic_TemplateMetaProc {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Map<Id, Opportunity> donationsMap;


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

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Opportunity.SObjectType);
        queryFactory.selectFields(this.getFields());
        queryFactory.setCondition('Id IN :recordIds');

        this.donationsMap = new Map<Id, Opportunity>((List<Opportunity>) Database.query(queryFactory.toSOQL()));
    }

    protected override void initMetadata(String componentId, vertic_DTO dto) {

        Opportunity donationVar = this.donationsMap.get(componentId);
        vertic_Utils.objects.throwIfBlank(donationVar, 'No Donation with Id: ' + componentId);

        new vertic_AutoMapper(dto)
            .getOptions()
            .setIsVisualforce(true)
            .setIsAllFields(true)
            .setDefaultFieldValue(' ')
            .getMapper()
            .mapAnyValue('currentYear', Date.today().year())
            .mapAnyValue('today', Date.today().format())
            .mapFromSObject('donation', donationVar)
            .mapFromSObject('recipient', donationVar.npsp__Primary_Contact__r)
            .mapFromSObject('organisation', donationVar.npsp__Primary_Contact__r.Account != null ? donationVar.npsp__Primary_Contact__r.Account : new Account())
            .mapFromListSObjects('donations', new List<Opportunity>{donationVar})
            .mapAnyValue('totalAmount', donationVar.Amount)
            .mapAnyValue('hasDonations', true);
    }

    protected override String getTemplate(String componentId, vertic_DTO dto) {

        Opportunity donation = this.donationsMap.get(componentId);

        if(donation == null){ return null; }

        Direct_Mail_Receipt_Template__c template = (Direct_Mail_Receipt_Template__c)vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                Envelope_Type__c,
                Header_Image__c,
                Receipt_Body_Text__c
            FROM Direct_Mail_Receipt_Template__c
            WHERE Campaign__c =: donation.CampaignId
            AND Minimum_Donation__c <: donation.Amount
            AND Maximum_Donation__c >: donation.Amount
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

    private List<String> getFields(){
        List<String> fields = new List<String>{
            'Name', 'Amount', 'CloseDate', 'Payment_Method__c', 'CampaignId',
            'npsp__Primary_Contact__r.Greeting__c',
            'npsp__Primary_Contact__r.Letter_Salutation__c',
            'npsp__Primary_Contact__r.FirstName',
            'npsp__Primary_Contact__r.LastName',
            'npsp__Primary_Contact__r.Name',
            'npsp__Primary_Contact__r.Salutation',
            'npsp__Primary_Contact__r.Title',
            'npsp__Primary_Contact__r.Email',
            'npsp__Primary_Contact__r.MailingStreet',
            'npsp__Primary_Contact__r.MailingCity',
            'npsp__Primary_Contact__r.MailingState',
            'npsp__Primary_Contact__r.MailingCountry',
            'npsp__Primary_Contact__r.MailingPostalCode',
            'npsp__Primary_Contact__r.Account.Name'
        };
        fields.addAll(getFormulaFields(Opportunity.SObjectType, null));
        fields.addAll(getFormulaFields(Contact.SObjectType, 'npsp__Primary_Contact__r.'));

        return fields;
    }

    public override List<vertic_TemplateMetaProc.MergeFieldsSet> getMergeFieldSets(){
        List<String> fields = this.getFields();
        return new List<vertic_TemplateMetaProc.MergeFieldsSet>{
            this.getMergeFieldSet(fields, Opportunity.SObjectType, Opportunity.SObjectType, 'donation.', null),
            this.getMergeFieldSet(fields, Opportunity.SObjectType, Contact.SObjectType, 'donor.', 'npsp__Primary_Contact__r.')
        };
    }

    protected override void afterProcess() {
        List<Object> components = this.response.getList('components');
        if (components.isEmpty()) {
            components.add(new Component.Apex.OutputText(value = 'No Donations'));
        }
        this.response.dto.put('components', components);
        this.response.dto.put('head-component', new Component.DefaultAnnualReceiptStyles());

        this.setFileName(ContributionService.formatReceiptFileName());

        Boolean afterProc = this.request.getBoolean('afterProc');
        if (afterProc == true) {
            this.doAfterProc(String.join(this.getIds(), ','));
        }
    }

    private void doAfterProc(String ids) {
        new DirectMailReceiptAfterProc().process(new Map<String, Object> {
            'ids' => ids
        });
    }

    public override SObjectType getSObjectType() {
        return Opportunity.SObjectType;
    }

}