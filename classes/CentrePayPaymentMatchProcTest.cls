@IsTest
private class CentrePayPaymentMatchProcTest {
    @IsTest
    static void testBehavior() {

        Contact contact = new Contact(

        );

        Map<String, Object> request = new Map<String, Object>{
            'centrelink_crn' => '1234'
        };


        new CentrePayPaymentMatchProc().process(request);
    }
}