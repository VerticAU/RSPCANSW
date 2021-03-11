public class ProcessPaymentsBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{

    private String batchId;

    public ProcessPaymentsBatch(String batchId){
        this.batchId = batchId;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(
            'SELECT Id, ' +
                'npsp_plus__Status__c, ' +
                'npe01__Payment_Method__c, ' +
                'npe01__Payment_Amount__c, ' +
                'Stripe_Customer_Id__c, ' +
                'Stripe_Payment_Id__c, ' +
                'npsp_plus__Gateway_Transaction_ID__c, ' +
                'npe01__Payment_Date__c, ' +
                'npe01__Paid__c, ' +
                'npe01__Written_Off__c, ' +
                'npsp__Payment_Acknowledgment_Status__c, ' +
                'npe01__Opportunity__r.Campaign.npsp_plus__Stripe_Account_Id__c ' +
            'FROM npe01__OppPayment__c WHERE Batch__c = \'' + this.batchId + '\' ' +
                'AND npe01__Paid__c = false'
        );
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        npe01__OppPayment__c payment = (npe01__OppPayment__c) scope[0];
        try {
            if(payment.npe01__Payment_Method__c == 'Credit Card'){

                vertic_Response response = new BulkContributionManagementPaymentProc().process(new Map<String, Object>{
                    'amount' => payment.npe01__Payment_Amount__c,
                    'stripeCustomerId' => payment.Stripe_Customer_Id__c,
                    'stripePaymentMethodId' => payment.Stripe_Payment_Id__c,
                    'stripeAccountId' => payment.npe01__Opportunity__r.Campaign.npsp_plus__Stripe_Account_Id__c
                });

                payment.npsp_plus__Gateway_Transaction_ID__c = response.getRequiredString('paymentIntentId');
            }

            payment.npe01__Payment_Date__c = payment.npe01__Payment_Date__c != null ? payment.npe01__Payment_Date__c : Date.today();
            payment.npe01__Written_Off__c = false;
            payment.npsp_plus__Status__c = 'Processed';
            payment.npe01__Paid__c = true;

            if(payment.npsp__Payment_Acknowledgment_Status__c == 'To Be Acknowledged'){
                payment.npsp__Payment_Acknowledgment_Status__c = 'Email Acknowledgment Now';
            }

        } catch (Exception e){
            payment.npe01__Payment_Date__c = payment.npe01__Payment_Date__c != null ? payment.npe01__Payment_Date__c : Date.today();
            payment.npsp_plus__Status__c = 'Failed';
            payment.npe01__Paid__c = false;
            System.debug(e.getMessage());
        } finally {
            update scope;
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('ProcessPaymentsBatch finished!');
    }
}