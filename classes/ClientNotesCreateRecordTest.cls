@IsTest
private class ClientNotesCreateRecordTest {
    @IsTest
    static void testClientNotesCreateRecordMetaProc() {

        Contact contact = new Contact(
            LastName = 'test'
        );

        Case aCase = new Case(
            ContactId = contact.Id,
            Status = 'New'
        );
        insert aCase;

        Map<String, Object> request = new Map<String, Object>{
            'recordId' => aCase.Id,
            'sObjectName' => 'Case',
            'contactRelation' => 'ContactId'
        };

        new ClientNotesCreateRecordMetaProc().process(request);

        Map<String, Object> request2 = new Map<String, Object>{
            'clientNote.caseman__Subject__c' => contact.Id
        };

        new ClientNotesCreateRecordSubmitProc().process(request2);

        System.Test.startTest();

        System.assertEquals(1, [SELECT Id FROM caseman__ClientNote__c WHERE caseman__Client__c =: contact.Id].size());

        System.Test.stopTest();
    }
}