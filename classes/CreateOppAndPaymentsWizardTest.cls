@IsTest
public class CreateOppAndPaymentsWizardTest {
    @IsTest static void testMeta(){
        new CreateOppAndPaymentsWizardMetaProc().process(new Map<String, Object>());

        Case caseVar = new Case(
            Price_Book__c = Test.getStandardPricebookId(),
            Assistance_Required__c = 'Boarding'
        );
        insert caseVar;

        Product2 product2 = new Product2(
            Name = 'test',
            IsActive = true
        );
        insert product2;

        PricebookEntry entry = new PricebookEntry(
            Product2Id = product2.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = 10,
            UseStandardPrice = false,
            IsActive = true
        );
        insert entry;

        pmdm__Program__c program = new pmdm__Program__c(
            Name = 'test',
            pmdm__Status__c = 'Active'
        );
        insert program;

        pmdm__Service__c service = new pmdm__Service__c(
            Product__c = product2.Id,
            pmdm__Program__c = program.Id
        );
        insert service;

        pmdm__ProgramEngagement__c engagement = new pmdm__ProgramEngagement__c(
            Case__c = caseVar.Id,
            pmdm__Program__c = program.Id,
            pmdm__Stage__c = 'Active',
            pmdm__Role__c = 'Client'
        );
        insert engagement;

        pmdm__ServiceDelivery__c delivery = new pmdm__ServiceDelivery__c(
            pmdm__Service__c = service.Id,
            pmdm__ProgramEngagement__c = engagement.Id,
            pmdm__Quantity__c = 1
        );
        insert delivery;

        vertic_Response response = new CreateOppAndPaymentsWizardSelectMetaProc().process(new Map<String, Object>{
            'recordId' => engagement.Id
        });

        System.assertNotEquals(null, response);
    }

    @IsTest static void testSubmit(){
        Contact contact = new Contact(
            LastName = 'test'
        );
        insert contact;

        Case caseVar = new Case(
            Price_Book__c = Test.getStandardPricebookId(),
            Assistance_Required__c = 'Boarding'
        );
        insert caseVar;

        pmdm__Program__c program = new pmdm__Program__c(
            Name = 'test',
            pmdm__Status__c = 'Active'
        );
        insert program;

        pmdm__ProgramEngagement__c engagement = new pmdm__ProgramEngagement__c(
            Case__c = caseVar.Id,
            pmdm__Program__c = program.Id,
            pmdm__Stage__c = 'Active',
            pmdm__Role__c = 'Client',
            pmdm__Contact__c = contact.Id
        );
        insert engagement;

        vertic_Request req = new vertic_Request();
        req.getMapper().mapFromSObject('opportunity', new Opportunity(
            Amount = 10,
            Program_Engagement__c = engagement.Id
        )).mapFromListSObjects('payments', new List<npe01__OppPayment__c>{
            new npe01__OppPayment__c(
                npsp_plus__Status__c = 'Processed',
                npe01__Payment_Method__c = 'Cash',
                npe01__Payment_Amount__c = 10
            )
        });

        new CreateOppAndPaymentsWizardSubmitProc().process(req);
        System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);
    }
}