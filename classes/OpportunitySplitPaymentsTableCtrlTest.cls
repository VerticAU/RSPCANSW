@IsTest
public class OpportunitySplitPaymentsTableCtrlTest {
    @IsTest
    static void testDonationOpp() {
        Id donationRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
            .get('Donation').getRecordTypeId();

        Opportunity donationOppVar = new Opportunity(
            Name = 'Donation OppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 100,
            RecordTypeId = donationRecordTypeId
        );
        insert donationOppVar;

        //Donation test
        OpportunitySplitPaymentsTableCtrl donationController = new OpportunitySplitPaymentsTableCtrl();

        donationController.opportunityId = donationOppVar.Id;
        donationController.initRecords();
        Opportunity donationOppVar1 = donationController.getOpportunity();
        List<Opportunity> donationOpportunitiesInTableList = donationController.getOpportunitiesInTable();
        Decimal donationPaymentTotalVar = donationController.getPaymentTotal();

        System.assertEquals(donationOppVar.Id, donationOppVar1.Id);
        System.assertEquals(donationOppVar.Id, donationOpportunitiesInTableList[0].Id);
        System.assertEquals(donationOppVar.Amount, donationPaymentTotalVar);
    }

    @IsTest
    static void testGiftCardOpp() {
        Id giftCardRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
            .get('Gift Card').getRecordTypeId();

        Opportunity giftCardOppVar = new Opportunity(
            Name = 'Gift CArd OppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 100,
            RecordTypeId = giftCardRecordTypeId
        );
        insert giftCardOppVar;

        //Gift Card test
        OpportunitySplitPaymentsTableCtrl giftCardController = new OpportunitySplitPaymentsTableCtrl();

        giftCardController.opportunityId = giftCardOppVar.Id;
        giftCardController.initRecords();
        Opportunity giftCardOppVar1 = giftCardController.getOpportunity();
        List<Opportunity> giftCardOpportunitiesInTableList = giftCardController.getOpportunitiesInTable();
        Decimal giftCardPaymentTotalVar = giftCardController.getPaymentTotal();

        System.assertEquals(giftCardOppVar.Id, giftCardOppVar1.Id);
        System.assertEquals(giftCardOppVar.Id, giftCardOpportunitiesInTableList[0].Id);
        System.assertEquals(giftCardOppVar.Amount, giftCardPaymentTotalVar);
    }

    @IsTest
    static void testSplitPaymentOpp() {
        Id donationRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
            .get('Donation').getRecordTypeId();
        Id giftCardRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
            .get('Gift Card').getRecordTypeId();
        Id splitPaymentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
            .get('Split Payment').getRecordTypeId();

        Opportunity splitPaymentOppVar = new Opportunity(
            Name = 'Split Payment OppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            RecordTypeId = splitPaymentRecordTypeId
        );
        insert splitPaymentOppVar;

        Opportunity donationOppVar = new Opportunity(
            Name = 'Donation OppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 100,
            RecordTypeId = donationRecordTypeId,
            Parent_Opportunity__c = splitPaymentOppVar.Id
        );
        Opportunity giftCardOppVar = new Opportunity(
            Name = 'Gift CArd OppVar',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 100,
            RecordTypeId = giftCardRecordTypeId,
            Parent_Opportunity__c = splitPaymentOppVar.Id
        );
        insert new List<Opportunity>{
            donationOppVar, giftCardOppVar
        };

        //Split Payment test
        OpportunitySplitPaymentsTableCtrl splitPaymentController = new OpportunitySplitPaymentsTableCtrl();

        splitPaymentController.opportunityId = splitPaymentOppVar.Id;
        splitPaymentController.initRecords();
        Opportunity splitPaymentOppVar1 = splitPaymentController.getOpportunity();
        List<Opportunity> splitPaymentOpportunitiesInTableList = splitPaymentController.getOpportunitiesInTable();
        Decimal splitPaymentPaymentTotalVar = splitPaymentController.getPaymentTotal();

        System.assertEquals(splitPaymentOppVar.Id, splitPaymentOppVar1.Id);
        System.assertEquals(2, splitPaymentOpportunitiesInTableList.size());
        System.assertEquals(200, splitPaymentPaymentTotalVar);
    }
}