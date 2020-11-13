public without sharing class ProfilePhotoUploadProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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

        this.savePhoto();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void savePhoto() {
        this.recordId = this.request.getId('recordId');

        Blob contentData = EncodingUtil.base64Decode(EncodingUtil.urlDecode(this.request.getString('base64Data'), 'UTF-8'));

        User userVar = (User) vertic_Utils.arrays.firstOrNull([
            SELECT ContactId
            FROM User
            WHERE Id = :this.recordId OR ContactId = :this.recordId
        ]);

        if (userVar != null) {
            ConnectApi.Photo newPhoto = ConnectApi.UserProfiles.setPhoto(null, userVar.Id,
                new ConnectApi.BinaryInput(
                    contentData,
                    this.request.getString('contentType'),
                    this.request.getString('fileName')
                )
            );

            this.response.put('photoUrl', newPhoto.largePhotoUrl);
            this.recordId = userVar.ContactId;
        }

        if (this.recordId != null) {
            Contact contactVar = (Contact) vertic_Utils.arrays.firstOrException([
                SELECT Name
                FROM Contact
                WHERE Id = :this.recordId
            ], 'Contact not found by ID: ' + this.recordId);

            String photoTitle = 'Profile Photo - ' + contactVar.Name;

            ContentVersion photoVersion = new ContentVersion(
                Title = photoTitle,
                VersionData = contentData,
                PathOnClient = this.request.getString('fileName')
            );

            ContentDocumentLink photoDocumentLink = (ContentDocumentLink) vertic_Utils.arrays.firstOrNull([
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :this.recordId
                AND ContentDocument.Title = :photoTitle
            ]);

            if (photoDocumentLink != null) {
                photoVersion.ContentDocumentId = photoDocumentLink.ContentDocumentId;
            } else {
                photoDocumentLink = new ContentDocumentLink(
                    LinkedEntityId = this.recordId,
                    ShareType = Test.isRunningTest() ? 'I' : 'V',
                    Visibility = 'AllUsers'
                );
            }

            insert photoVersion;

            if (photoDocumentLink.ContentDocumentId == null) {
                photoDocumentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :photoVersion.Id].ContentDocumentId;
                insert photoDocumentLink;
            }

            ContentDistribution photoDistribution = new ContentDistribution(
                Name = photoVersion.Title,
                ContentVersionId = photoVersion.Id,
                PreferencesAllowViewInBrowser = true,
                PreferencesLinkLatestVersion = true,
                PreferencesNotifyOnVisit = false,
                PreferencesPasswordRequired = false,
                PreferencesAllowOriginalDownload = true,
                PreferencesAllowPDFDownload = true
            );
            insert photoDistribution;
            photoDistribution = (ContentDistribution) vertic_Utils.arrays.firstOrException([SELECT ContentDownloadUrl FROM ContentDistribution WHERE Id = :photoDistribution.Id]);

            if (userVar == null) {
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