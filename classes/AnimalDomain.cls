public without sharing class AnimalDomain extends fflib_SObjectDomain implements fflib_ISObjectDomain {

    public AnimalDomain(List<Animal__c> sObjectList) {
        super(sObjectList);
        this.Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new AnimalDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        this.calculateBirthdate(this.Records);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        this.calculateBirthdate(
            this.filterByChangedFields(
                this.Records, existingRecords,
                new List<String>{'Age_Week_s__c', 'Age_Month_s__c', 'Age_Year_s__c'})
        );
    }

    public override void onAfterInsert() {}
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {}

    private List<Animal__c> filterByChangedFields(List<Animal__c> newRecords, Map<Id, SObject> existingRecords, List<String> fieldsToCheck){
        List<Animal__c> changedRecords = new List<Animal__c>();
        for(Animal__c animal : newRecords){
            if(vertic_Utils.sObjects.isSomeFieldChanged(animal, existingRecords.get(animal.Id), fieldsToCheck)){
                changedRecords.add(animal);
            }
        }
        return changedRecords;
    }

    private void calculateBirthdate(List<Animal__c> animals){
        for(Animal__c animal : animals){
            animal.Age_Entered_Date__c = Date.today();

            Date birthdate = animal.Age_Entered_Date__c;
            if(animal.Age_Week_s__c != null){
                birthdate = birthdate.addDays(-7 * animal.Age_Week_s__c.intValue());
            }
            if(animal.Age_Month_s__c != null){
                birthdate = birthdate.addMonths(-animal.Age_Month_s__c.intValue());
            }
            if(animal.Age_Year_s__c != null){
                birthdate = birthdate.addYears(-animal.Age_Year_s__c.intValue());
            }

            if(animal.Age_Month_s__c == null && animal.Age_Week_s__c == null && animal.Age_Year_s__c == null){
                animal.Birthdate__c = null;
            } else {
                animal.Birthdate__c = birthdate;
            }

        }
    }
}