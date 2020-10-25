/**
 * Created by Vladimir on 25/10/2020.
 */
@isTest
public with sharing class EstateManagementQASubmitProcTest {

    @isTest
    private static void test() {
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact cnt = new Contact(LastName = 'test', Email = 'test@test.test', AccountId = acc.Id);
        insert cnt;
        Opportunity opp = new Opportunity(
                Name = 'test',
                StageName = 'Enquiry',
                CloseDate = Date.today());
        insert opp;
        List<npe5__Affiliation__c> affiliations = new List<npe5__Affiliation__c>();
        insert affiliations;

        new EstateManagementQASubmitProc().process(new vertic_Request(new Map<String,Object>{
                'opportunity' => opp,
                'account' => acc,
                'opportunity.npsp__Primary_Contact__r' => cnt
        }));

    }
}