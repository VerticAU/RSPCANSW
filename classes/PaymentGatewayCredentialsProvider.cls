public class PaymentGatewayCredentialsProvider {

    public static final String EZIDEBIT_PAYMENT_CREDENTIALS_SANDBOX = 'EZIDEBIT_SANDBOX';
    public static final String EZIDEBIT_PAYMENT_CREDENTIALS_LIVE = 'EZIDEBIT_LIVE';
    public static final String PAYMENT_TRANSACTION_PAYMENT_METHOD_EZIDEBIT = 'EZIDEBIT';

    public static final Map<String, String> PAYMENT_METHOD_TO_SANDBOX_PAYMENT_CREDENTIALS = new Map<String, String> {
        PAYMENT_TRANSACTION_PAYMENT_METHOD_EZIDEBIT => EZIDEBIT_PAYMENT_CREDENTIALS_SANDBOX
    };
    public static final Map<String, String> PAYMENT_METHOD_TO_LIVE_PAYMENT_CREDENTIALS = new Map<String, String> {
        PAYMENT_TRANSACTION_PAYMENT_METHOD_EZIDEBIT => EZIDEBIT_PAYMENT_CREDENTIALS_LIVE
    };

    public static Payment_Gateway_Credentials__c getGatewayCredentials(String paymentMethod){

        final String PAYMENT_CREDENTIALS_SANDBOX = PAYMENT_METHOD_TO_SANDBOX_PAYMENT_CREDENTIALS.get(paymentMethod);
        final String PAYMENT_CREDENTIALS_LIVE = PAYMENT_METHOD_TO_LIVE_PAYMENT_CREDENTIALS.get(paymentMethod);

        Payment_Gateway_Credentials__c credentials = selectCredentials(PAYMENT_CREDENTIALS_SANDBOX);
        if (credentials == null) {
            credentials = selectCredentials(PAYMENT_CREDENTIALS_LIVE);
        }
        if (credentials == null) {
            throw new vertic_Structs.MissingDataException(
                'No active Payment Credentials with name \'' + PAYMENT_CREDENTIALS_SANDBOX +
                    '\' or with name \'' + PAYMENT_CREDENTIALS_LIVE + '\''
            );
        }
        return credentials;
    }

    private static Payment_Gateway_Credentials__c selectCredentials(String credentialsName){
        return (Payment_Gateway_Credentials__c) vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                API_Key__c,
                API_Password__c,
                API_Signature__c,
                API_Username__c,
                Is_Active__c,
                Is_Test__c,
                URL__c
            FROM Payment_Gateway_Credentials__c
            WHERE Name =: credentialsName
            LIMIT 1
        ]);
    }
}