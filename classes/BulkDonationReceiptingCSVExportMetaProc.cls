public class BulkDonationReceiptingCSVExportMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new vertic_MetadataProcessor.MetadataRequest() : (vertic_MetadataProcessor.MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.init();
        this.mapResponse();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */


    public void init(){
        if(this.settingsVar == null){
            this.settingsVar = (npsp_plus__Settings__mdt) vertic_Utils.arrays.firstOrNull([
                SELECT Id,
                    npsp_plus__Payload__c,
                    npsp_plus__Default_Org_Wide_Email__c,
                    npsp_plus__Donation_Receipt_Email_Template_Name__c,
                    npsp_plus__Crypto_Key__c,
                    npsp_plus__Crypto_HMac_Key__c,
                    npsp_plus__Version__c
                FROM npsp_plus__Settings__mdt
                WHERE DeveloperName = 'Settings'
                ORDER BY Id DESC
            ]);
        }

        String payloadStr = this.settingsVar == null || this.settingsVar.npsp_plus__Payload__c == null ? '{}' : this.settingsVar.npsp_plus__Payload__c;

        Map<String, Object> settingsMap;
        try {
            settingsMap = (Map<String, Object>) JSON.deserializeUntyped(payloadStr);
        } catch (Exception e) {
            settingsMap = new Map<String, Object>();
        }

        this.settingsDTO = new vertic_DTO(settingsMap);
    }

    private void mapResponse() {
        this.response.put('reportId', this.settingsDTO.getString('export.oneOffDonationsReportId'));
    }


    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    @TestVisible
    private npsp_plus__Settings__mdt settingsVar;

    @TestVisible
    private vertic_DTO settingsDTO;
}