public without sharing class AccountDomain extends fflib_SObjectDomain implements fflib_ISObjectDomain {

    public AccountDomain(List<Account> sObjectList) {
        super(sObjectList);
        this.Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new AccountDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        this.populateLGA(this.Records);
    }
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        this.populateLGA(
            this.filterByChangedFields(
                this.Records,
                existingRecords,
                new List<String>{'BillingCity', 'BillingPostalCode'})
        );
    }

    public override void onAfterInsert() {}
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {}

    private List<Account> filterByChangedFields(List<Account> newRecords, Map<Id, SObject> existingRecords, List<String> fieldsToCheck){
        List<Account> changedRecords = new List<Account>();
        for(Account account : newRecords){
            if(vertic_Utils.sObjects.isSomeFieldChanged(account, existingRecords.get(account.Id), fieldsToCheck)){
                changedRecords.add(account);
            }
        }
        return changedRecords;
    }

    private void populateLGA(List<Account> accounts){
        Set<String> cityValues = vertic_Utils.sObjects.getStringFieldValues(accounts, 'BillingCity');
        Set<String> postcodeValues = vertic_Utils.sObjects.getStringFieldValues(accounts, 'BillingPostalCode');

        List<Postcode__c> postcodes = [
            SELECT Id, LGA__c, Postcode__c, Suburb__c
            FROM Postcode__c
            WHERE Suburb__c IN :cityValues
            AND Postcode__c IN :postcodeValues
            AND LGA__c != NULL
            AND Suburb__c != NULL
            AND Postcode__c != NULL
        ];

        for(Account account: accounts){
            for(Postcode__c postcode: postcodes){
                if(account.BillingCity == postcode.Suburb__c && account.BillingPostalCode == postcode.Postcode__c){
                    account.LGA__c = postcode.LGA__c;
                    continue;
                }
            }
        }
    }
}