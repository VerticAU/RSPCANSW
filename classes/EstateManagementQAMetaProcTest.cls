/**
 * Created by Vladimir on 25/10/2020.
 */
@isTest
public with sharing class EstateManagementQAMetaProcTest {
    @isTest
    private static void test() {
        Contact contact = new Contact (LastName = 'test');
        insert contact;
        Opportunity opp = new Opportunity(
                Name = 'test',
                StageName = 'Enquiry',
                CloseDate = Date.today(),
                npsp__Primary_Contact__c = contact.Id,
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByName(Opportunity.SObjectType, 'Bequest'));
        insert opp;

        vertic_Response response = new EstateManagementQAMetaProc().process(new Map<String, Object>{
                'recordId' => contact.Id
        });

        System.assertNotEquals(null, response.get('opportunity'));
    }
}