@IsTest
public class ClientNotesTargetedTableTest {
    @IsTest static void testMetaProc(){
        Account account = new Account(
            Name = 'Test'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'Test'
        );
        insert contact;

        Case caseVar = new Case(
            Subject = 'Test',
            ContactId = contact.Id
        );
        insert caseVar;

        caseman__ClientNote__c note = new caseman__ClientNote__c(
            caseman__Client__c = contact.Id,
            Case__c = caseVar.Id,
            caseman__Content__c = 'test'
        );
        insert note;

        vertic_Response response = new ClientNotesTargetedTableMetaProc().process(new Map<String, Object>{
            'recordId' => caseVar.Id,
            'sObjectName' => 'Case',
            'contactRelation' => 'ContactId'
        });

        List<caseman__ClientNote__c> notes = response.getMapper().mapToListSObjects('notes.records', caseman__ClientNote__c.SObjectType);
        System.assertEquals(1, notes.size());

        response = new ClientNotesTargetedTableMetaProc().process(new Map<String, Object>{
            'recordId' => caseVar.Id,
            'sObjectName' => 'Case',
            'targetRelation' => 'Case__c'
        });

        notes = response.getMapper().mapToListSObjects('notes.records', caseman__ClientNote__c.SObjectType);
        System.assertEquals(1, notes.size());
    }

}