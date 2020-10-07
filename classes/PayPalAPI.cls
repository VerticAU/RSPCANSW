public class PayPalAPI {
    /*
    curl -v https://api.sandbox.paypal.com/v1/oauth2/token \
   -H "Accept: application/json" \
   -H "Accept-Language: en_US" \
   -u "client_id:secret" \
   -d "grant_type=client_credentials"
     */
    private String endpoint = 'https://api.sandbox.paypal.com';
    private String clientId = 'AV71Dh0JikFB8ch0NkMyI_qImNWj4Ml6HA0iHMSzDJk9hTws9rNAuySHPFNjIEqUdV1tJmxU9bfUxyXW';
    private String clientSecret = 'ECZ-owQLzgW_AU9TD527iZBVfBatEysJzZwcGm0ZSRvdhU46cWE67t0Y2Ap5NEhix8pJGhewBAyAgpqH';

    public vertic_DTO getTokenDTO(){

        Blob headerValue = Blob.valueOf(this.clientId + ':' + this.clientSecret);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(String.format('{0}/v1/oauth2/token', new List<String>{
            this.endpoint
        }));
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Accept-Language', 'en_US');
        request.setHeader('Authorization', authorizationHeader);
        request.setBody('grant_type=client_credentials');

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(res.getBody());

        System.assertEquals(200, res.getStatusCode(), res.getStatus());

        vertic_DTO responseDTO = new vertic_DTO(res.getBody());

        return responseDTO;
    }

    public vertic_DTO refund(String saleId){
        String authorizationHeader = 'Bearer ' + this.getTokenDTO().getRequiredString('access_token');

        HttpRequest request = new HttpRequest();
        request.setEndpoint(String.format('{0}/v1/payments/sale/{1}/refund', new List<String>{
            this.endpoint,
            saleId
        }));
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', authorizationHeader);

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(res.getBody());

        System.assertEquals(201, res.getStatusCode(), res.getStatus());

        vertic_DTO responseDTO = new vertic_DTO(res.getBody());

        return responseDTO;
    }


}