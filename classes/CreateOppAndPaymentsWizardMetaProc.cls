public without sharing class CreateOppAndPaymentsWizardMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{};

        super.process(this.request);

        this.init();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {

        this.pricebookId = this.request.getString('pricebookId');

        if(String.isBlank(this.pricebookId)){
            this.programEngagement = (pmdm__ProgramEngagement__c) vertic_Utils.arrays.firstOrException([
                SELECT Id,
                    Case__r.Price_Book__c,
                    Event__r.Price_Book__c
                FROM pmdm__ProgramEngagement__c
                WHERE Id = :this.request.getRequiredString('recordId')
            ]);

            this.pricebookId = vertic_Utils.strings.defaultIfBlank(this.programEngagement.Case__r.Price_Book__c, this.programEngagement.Event__r.Price_Book__c);

            if(String.isBlank(this.pricebookId)){ return; }
        }

        List<pmdm__ServiceDelivery__c> serviceDeliveries = [
            SELECT Id,
                pmdm__Quantity__c,
                pmdm__Service__r.Product__c
            FROM pmdm__ServiceDelivery__c
            WHERE pmdm__ProgramEngagement__c = :this.programEngagement.Id
            AND pmdm__Service__r.Product__r.IsActive = TRUE
        ];

        Map<String, Decimal> productQuntityMap = new Map<String, Decimal>();
        for(pmdm__ServiceDelivery__c delivery : serviceDeliveries){
            productQuntityMap.put(delivery.pmdm__Service__r.Product__c, delivery.pmdm__Quantity__c);
        }

        List<PricebookEntry> pricebookEntries = [
            SELECT Id,
                UnitPrice,
                Product2Id,
                Product2.Name
            FROM PricebookEntry
            WHERE Pricebook2Id =: this.pricebookId
            AND Product2Id IN :productQuntityMap.keySet()
        ];

        List<ProductItemWrapper> wrappers = new List<ProductItemWrapper>();
        for(PricebookEntry entry: pricebookEntries){
            wrappers.add(new ProductItemWrapper(
                entry.Product2.Name,
                entry.UnitPrice,
                productQuntityMap.get(entry.Product2Id)
            ));
        }

        this.response.put('productItems', wrappers);
        this.response.put('pricebookId', this.pricebookId);
    }

    private pmdm__ProgramEngagement__c programEngagement;
    private String pricebookId;

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    public class ProductItemWrapper {
        public String name;
        public Decimal quantity;
        public Decimal price;

        public ProductItemWrapper(String name, Decimal quantity, Decimal price){
            this.name = name;
            this.quantity = quantity;
            this.price = price;
        }
    }
}