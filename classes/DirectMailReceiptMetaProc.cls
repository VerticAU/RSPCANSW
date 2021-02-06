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
        Boolean isIndividual = donationVar.npsp__Primary_Contact__c != null;

        Contact recipient;
        Account organisation;
        if(isIndividual){
            recipient = donationVar.npsp__Primary_Contact__r;
            organisation = recipient.Account;
        } else {
            if(donationVar.Account.npe01__One2OneContact__c != null){
                recipient = donationVar.Account.npe01__One2OneContact__r;
            }
            organisation = donationVar.Account;
        }

        vertic_Utils.objects.throwIfBlank(donationVar, 'No Donation with Id: ' + componentId);

        List<String> args = new String[]{'0','number','###,###,##0.00'};
        String formattedAmount = String.format(donationVar.Amount.format(), args);

        vertic_AutoMapper autoMapper = new vertic_AutoMapper(dto)
            .getOptions()
            .setIsVisualforce(true)
            .setIsAllFields(true)
            .setDefaultFieldValue(' ')
            .getMapper()
            .mapAnyValue('currentYear', Date.today().year())
            .mapAnyValue('today', Date.today().format())
            .mapFromSObject('donation', donationVar)
            .mapFromListSObjects('donations', new List<Opportunity>{donationVar})
            .mapAnyValue('totalAmount', donationVar.Amount)
            .mapAnyValue('totalAmountFormatted', formattedAmount)
            .mapAnyValue('hasDonations', true);

        if(recipient != null){ autoMapper.mapFromSObject('recipient', recipient); }
        if(organisation != null){ autoMapper.mapFromSObject('organisation', organisation); }
    }

    protected override String getTemplate(String componentId, vertic_DTO dto) {

        Opportunity donation = this.donationsMap.get(componentId);

        if(donation == null){ return '<p>Donation is not found.<\\p><p>Donation: ' + componentId + '<\\p>'; }

        Direct_Mail_Receipt_Template__c template;
        String campaignId = donation.CampaignId;

        while (template == null){
            if(Limits.getLimitQueries() < 10 || campaignId == null){
                break;
            }
            template = queryTemplate(donation, campaignId);
            campaignId = getParentCampaignId(campaignId);
        }

        if(template == null){
            return '<p>Template is no found.<\\p>' +
            '<p>Donation: ' + donation.Id + '<\\p>' +
            '<p>Campaign: ' + donation.CampaignId + '<\\p>' +
            '<p>Amount: $' + donation.Amount + '<\\p>';
        }

        dto.put('imageUrl', template.Header_Image__c);
        dto.put('envelopeType', template.Envelope_Type__c);

        return template.Receipt_Body_Text__c;
    }

    private Direct_Mail_Receipt_Template__c queryTemplate(Opportunity donation, String campaignId){
        return (Direct_Mail_Receipt_Template__c) vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                Envelope_Type__c,
                Header_Image__c,
                Receipt_Body_Text__c,
                Campaign__c
            FROM Direct_Mail_Receipt_Template__c
            WHERE Campaign__c =: campaignId
            AND Minimum_Donation__c <: donation.Amount
            AND Maximum_Donation__c >: donation.Amount
        ]);
    }

    private String getParentCampaignId(String campaignId){
        Campaign campaign = (Campaign) vertic_Utils.arrays.firstOrNull([
            SELECT Id, ParentId
            FROM Campaign
            WHERE Id =: campaignId
        ]);
        return campaign.ParentId;
    }

    protected override ApexPages.Component getComponentInstance(String name, vertic_DTO dto) {
        String envelopeType = vertic_Utils.strings.defaultIfBlank(dto.getString('envelopeType'), 'DLX');
        if ('DirectMailReceiptTable'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptTable(dto = dto.getMap());
        } else if ('DirectMailReceiptImage'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptImage(dto = dto.getMap());
        } else if ('DirectMailReceiptDLVC'.equalsIgnoreCase(name)) {
            return new Component.DirectMailReceiptDLVC(dto = dto.getMap());
        } else if ('DirectMailReceiptAddress'.equalsIgnoreCase(name) && envelopeType == 'DLX') {
            return new Component.DirectMailReceiptAddressDLX(dto = dto.getMap());
        } else if ('DirectMailReceiptAddress'.equalsIgnoreCase(name) && envelopeType == 'C5') {
            return new Component.DirectMailReceiptAddressC5(dto = dto.getMap());
        }
        return null;
    }

    private List<String> getFields(){
        List<String> fields = new List<String>{
            'Name', 'Amount', 'CloseDate', 'Payment_Method__c', 'CampaignId', 'Campaign.Name', 'Receipt_Number__c',
            'npsp__Primary_Contact__r.Greeting__c',
            'npsp__Primary_Contact__r.Letter_Salutation__c',
            'npsp__Primary_Contact__r.Contact_Id__c',
            'npsp__Primary_Contact__r.Care_Of__c',
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
            'npsp__Primary_Contact__r.Account.Name',

            'Account.Name',
            'Account.npe01__One2OneContact__r.Greeting__c',
            'Account.npe01__One2OneContact__r.Letter_Salutation__c',
            'Account.npe01__One2OneContact__r.Contact_Id__c',
            'Account.npe01__One2OneContact__r.Care_Of__c',
            'Account.npe01__One2OneContact__r.FirstName',
            'Account.npe01__One2OneContact__r.LastName',
            'Account.npe01__One2OneContact__r.Name',
            'Account.npe01__One2OneContact__r.Salutation',
            'Account.npe01__One2OneContact__r.Title',
            'Account.npe01__One2OneContact__r.Email',
            'Account.npe01__One2OneContact__r.MailingStreet',
            'Account.npe01__One2OneContact__r.MailingCity',
            'Account.npe01__One2OneContact__r.MailingState',
            'Account.npe01__One2OneContact__r.MailingCountry',
            'Account.npe01__One2OneContact__r.MailingPostalCode'
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