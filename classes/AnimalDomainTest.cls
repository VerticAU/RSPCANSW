@IsTest
public class AnimalDomainTest {

    @IsTest static void test(){

        Animal__c animal = new Animal__c(
            Animal_Name__c = 'Tuzik',
            Age_Week_s__c = 1,
            Age_Month_s__c = 1,
            Age_Year_s__c = 1
        );
        insert animal;

        System.assertNotEquals(null, [SELECT Id, Birthdate__c FROM Animal__c LIMIT 1].Birthdate__c);

        animal.Age_Week_s__c = 2;
        update animal;

        System.assertNotEquals(null, [SELECT Id, Birthdate__c FROM Animal__c LIMIT 1].Birthdate__c);
    }
}