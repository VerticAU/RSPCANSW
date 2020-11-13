global without sharing class ProfilePhotoMetaProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Id recordId;


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();

        if (this.recordId.getSobjectType() == User.SObjectType) {
            this.getUserPhoto();
        } else if (this.recordId.getSobjectType() == Contact.SObjectType) {
            if (!this.getUserPhoto()) {
                this.getContactPhoto();
            }
        }

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        this.recordId = (Id) this.request.getRequiredString('recordId');
    }

    private Boolean getUserPhoto() {
        User userVar = (User) vertic_Utils.arrays.firstOrNull([
            SELECT FullPhotoUrl, FirstName, LastName, Name
            FROM User
            WHERE Id = :this.recordId OR ContactId = :this.recordId
        ]);

        if (userVar != null) {
            this.response.put('photoUrl', userVar.FullPhotoUrl);
            this.response.put('initials', (
                String.isNotBlank(userVar.FirstName) ?
                    (userVar.FirstName.substring(0, 1) + userVar.LastName.substring(0, 1)) :
                    userVar.LastName.substring(0, 2)
            ).toUpperCase());
            this.response.put('name', userVar.Name);
        }

        return userVar != null;
    }

    private void getContactPhoto() {
        Contact contactVar = (Contact) vertic_Utils.arrays.firstOrException([
            SELECT FirstName, LastName, Name
            FROM Contact
            WHERE Id = :this.recordId
        ], 'Contact not found by ID: ' + this.recordId);

        this.response.put('initials', (
            String.isNotBlank(contactVar.FirstName) ?
                (contactVar.FirstName.substring(0, 1) + contactVar.LastName.substring(0, 1)) :
                contactVar.LastName.substring(0, 2)
        ).toUpperCase());
        this.response.put('name', contactVar.Name);

        String photoTitle = 'Profile Photo - ' + contactVar.Name;

        ContentDocumentLink photoDocumentLink = (ContentDocumentLink) vertic_Utils.arrays.firstOrNull([
            SELECT ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :this.recordId
            AND ContentDocument.Title = :photoTitle
        ]);
        if (photoDocumentLink != null) {
            ContentDistribution photoDistribution = (ContentDistribution) vertic_Utils.arrays.firstOrNull([
                SELECT ContentDownloadUrl
                FROM ContentDistribution
                WHERE ContentVersionId = :photoDocumentLink.ContentDocument.LatestPublishedVersionId
                OR ContentDocumentId = :photoDocumentLink.ContentDocumentId
            ]);
            if (photoDistribution != null) {
                this.response.put('photoUrl', photoDistribution.ContentDownloadUrl);
            }
        }
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties: 
    // vertic_request
    // vertic_response

}