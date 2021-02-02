@IsTest
private class vertic_UpdateRecordsBatchTest {
    static testMethod void testBehavior() {
        Contact contactVar = new Contact(
            FirstName = 'test',
            LastName = 'test',
            Email = 'test@test.com'
        );
        insert contactVar;

        Test.startTest();

        contactVar.FirstName = 'test2';

        new vertic_UpdateRecordsBatch(new Map<Id, SObject>{contactVar.Id => contactVar})
            .setConditions(new List<String>())
            .addCondition('FirstName = \'test\'')
            .setOptAllOrNone(false)
            .setDisabledDomains(new Set<Type>())
            .addDisabledDomain(null)
            .run(1);

        Test.stopTest();

        System.assertEquals('test2', [SELECT FirstName FROM Contact WHERE Id = :contactVar.Id].FirstName);
    }
}