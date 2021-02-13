@IsTest
private class AddPaymentWizardMetaProcTest {
    static testMethod void testBehavior() {
        vertic_Response response = new AddPaymentWizardMetaProc().process(new Map<String, Object>{});
        System.assert(response.isValid);
    }
}