/**
 * Created by Vladimir on 25/10/2020.
 */
@isTest
public with sharing class EstateManagementQASubmitProcTest {

    @isTest
    private static void test() {
        Account acc = new Account(Name = 'test');

        Contact cnt = new Contact(LastName = 'test', Email = 'test@test.test');
        insert cnt;

        insert new Opportunity(
                Name = 'test',
                npsp__Primary_Contact__c = cnt.Id,
                StageName = 'Enquiry',
                CloseDate = Date.today()
        );

        Opportunity opp = [
            SELECT Id,
                npsp__Primary_Contact__r.Id,
                StageName,
                CloseDate
            FROM Opportunity
            LIMIT 1
        ];

        List<npe5__Affiliation__c> affiliations = new List<npe5__Affiliation__c>();

        new EstateManagementQASubmitProc().process(new vertic_Request(new Map<String,Object>{
                'opportunity' => new vertic_AutoMapper().getSObjectAsMap(opp),
                'account' => new vertic_AutoMapper().getSObjectAsMap(acc),
                'affiliations'=> new vertic_AutoMapper().getSObjectsAsMaps(affiliations)
        }));


        System.assertNotEquals(0, [SELECT COUNT() FROM AccountContactRelation]);
    }
}