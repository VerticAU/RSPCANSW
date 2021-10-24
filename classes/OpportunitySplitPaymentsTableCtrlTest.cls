@IsTest
public class OpportunitySplitPaymentsTableCtrlTest {
    @IsTest static void test() {
        Contact primaryContactVar = new Contact(
            LastName = 'Test primary contacn',
            MailingCity = 'Test Mailing City',
            MailingState = 'Test Mailing State',
            MailingCountry = 'Test Mailing Country',
            MailingPostalCode = '123445'
        );
        insert primaryContactVar;

        Opportunity oppVar = new Opportunity(
            Name = 'oppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            npsp__Primary_Contact__c = primaryContactVar.Id
        );
        oppVar.RecordType.Name = 'Split Payment';
        insert oppVar;

        OpportunitySplitPaymentsTableCtrlTest controller = new OpportunitySplitPaymentsTableCtrlTest();




    }
}