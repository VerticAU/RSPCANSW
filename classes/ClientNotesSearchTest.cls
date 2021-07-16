@IsTest
public class ClientNotesSearchTest {
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
            Subject = 'Test'
        );
        insert caseVar;

        pmdm__Program__c program = new pmdm__Program__c(
            pmdm__Status__c = 'Active'
        );
        insert program;

        pmdm__ProgramEngagement__c programEngagement = new pmdm__ProgramEngagement__c(
            pmdm__Program__c = program.Id
        );
        insert programEngagement;

        vertic_Response response = new ClientNotesSearchMetaProc().process(new Map<String, Object>{
            'filterRecordId' => UserInfo.getUserId()
        });
        System.assertEquals(UserInfo.getUserId(), response.get('filter.userId'));
        response = new ClientNotesSearchMetaProc().process(new Map<String, Object>{
            'filterRecordId' => contact.Id
        });
        System.assertEquals(contact.Id, response.get('filter.contactId'));
        response = new ClientNotesSearchMetaProc().process(new Map<String, Object>{
            'filterRecordId' => caseVar.Id
        });
        System.assertEquals(caseVar.Id, response.get('filter.caseId'));
        response = new ClientNotesSearchMetaProc().process(new Map<String, Object>{
            'filterRecordId' => programEngagement.Id
        });
        System.assertEquals(programEngagement.Id, response.get('filter.programEngagementId'));
        response = new ClientNotesSearchMetaProc().process(new Map<String, Object>{
            'filterRecordId' => account.Id
        });
        System.assertEquals(null, response.get('filter'));
    }
}