/**
 * Created by Vladimir on 26/10/2020.
 */
@isTest
public with sharing class FlowPostProcTest {
    @isTest
    private static void test() {

        User user = [SELECT Name,Id FROM User LIMIT 1];
        Event event = new Event(Subject = 'Call', OwnerId = user.Id, StartDateTime = Date.today(), EndDateTime = Date.today());



        vertic_RestService.Request request = new vertic_RestService.Request();

        request.params.put('event', JSON.serialize(event));
        request.params.put('flow','');

        new FlowPostProc().process(request);

    }
}