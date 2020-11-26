@IsTest
private class ProfilePhotoUploadProcTest {
    static testMethod void testBehavior() {

        Account account = new Account(
                Name = 'testName'
        );
        insert account;

        Contact contactVar = new Contact(
                LastName = 'test',
                AccountId = account.id
        );
        insert contactVar;

        vertic_Response response = new ProfilePhotoUploadProc().process(new Map<String, Object>{
            'recordId' => contactVar.Id,
            'base64Data' => 'dGVzdA==',
            'contentType' => 'image',
            'fileName' => 'test'
        });
        System.assertEquals(true, response.isValid, JSON.serialize(response.errors));


        response = new ProfilePhotoMetaProc().process(new Map<String, Object>{
            'recordId' => contactVar.Id
        });
        System.assertEquals(true, response.isValid, JSON.serialize(response.errors));
    }
}