@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    private Map<String, String> endpointResponseMap;
    private String method;
    private Integer statusCode;

    global MockHttpResponseGenerator(Map<String, String> endpointResponseMap, String method, Integer statusCode){
        this.endpointResponseMap = endpointResponseMap;
        this.method = method;
        this.statusCode = statusCode;
    }

    global HttpResponse respond(HttpRequest req) {
        System.debug(req.getEndpoint());
        System.assert(endpointResponseMap.containsKey(req.getEndpoint()), 'No Mock endpoint: ' + req.getEndpoint());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(endpointResponseMap.get(req.getEndpoint()));
        res.setStatusCode(statusCode);
        return res;
    }
}