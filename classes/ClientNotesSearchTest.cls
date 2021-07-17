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

    @IsTest static void testSubmitProc(){
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
            pmdm__Program__c = program.Id,
            pmdm__Contact__c = contact.Id
        );
        insert programEngagement;

        caseman__ClientNote__c note = new caseman__ClientNote__c(
            caseman__Client__c = contact.Id,
            Case__c = caseVar.Id,
            caseman__ProgramEngagement__c = programEngagement.Id,
            caseman__TypeOfInteraction__c = 'Phone Call',
            caseman__Content__c = 'test',
            Interaction_Date_Time__c = Datetime.now()
        );
        insert note;

        vertic_Response response = new ClientNotesSearchSubmitProc().process(new Map<String, Object>{
            'filter' => new Map<String, Object>{
                'startDate' => Date.today().addYears(-1),
                'endDate' => Date.today(),
                'contactId' => contact.Id,
                'userId' => UserInfo.getUserId(),
                'caseId' => caseVar.Id,
                'programEngagementId' => programEngagement.Id,
                'typeOfInteraction' => 'Phone Call'
            }
        });

        List<caseman__ClientNote__c> notes = response.getMapper().mapToListSObjects('notes.records', caseman__ClientNote__c.SObjectType);
        System.assertEquals(1, notes.size());

        Test.setFixedSearchResults(new List<Id>{ note.Id });

        response = new ClientNotesSearchSubmitProc().process(new Map<String, Object>{
            'filter' => new Map<String, Object>{
                'startDate' => Date.today().addYears(-1),
                'endDate' => Date.today(),
                'contactId' => contact.Id,
                'userId' => UserInfo.getUserId(),
                'caseId' => caseVar.Id,
                'programEngagementId' => programEngagement.Id,
                'typeOfInteraction' => 'Phone Call',
                'keyword' => 'test;text',
                'fuzzy' => true
            }
        });

        notes = response.getMapper().mapToListSObjects('notes.records', caseman__ClientNote__c.SObjectType);
        System.assertEquals(1, notes.size());
    }
}