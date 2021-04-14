({
    handleInit: function (cmp, event, helper) {

        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;
        cmp.set('v.isBusy', true);

        console.log('sObjectName', sObjectName);
        console.log('recordName', recordName);
        var oneDriveUtils = cmp.find("OneDriveUtils");

        oneDriveUtils.driveItems(sObjectName, recordName, null).then(function (files) {
            cmp.set('v.isFiles', false);

            if (files.length > 0) {
                files.sort(function (a, b) {
                    return new Date(b.createdDateTime) - new Date(a.createdDateTime);
                }).map(function (file) {
                    if (file.name.includes('DELETED_')) {
                        cmp.set('v.isRestore', true);
                    }
                    if (!file.name.includes('DELETED_')) {
                        cmp.set('v.isFiles', true);
                    }
                });
                cmp.set('v.meta.dto.files', files);
            }
        }).catch(function (reason) {

        }).finally(function () {
            cmp.set('v.isBusy', false);
            cmp.set('v.isFirst', false);
        });
    },

    handleFilesChange: function (cmp, event, helper) {
        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;
        var files = event.getSource().get("v.files");

        cmp.set('v.isBusy', true);
        var oneDriveUtils = cmp.find("OneDriveUtils");

        oneDriveUtils.upload(files, sObjectName, recordName).then(function (value) {
            oneDriveUtils.driveItems(sObjectName, recordName, null)
                .then(function (response) {
                    response.sort(function (a, b) {
                        return new Date(b.createdDateTime) - new Date(a.createdDateTime);
                    }).map(function (file) {
                        if (file.name.includes('DELETED_')) {
                            cmp.set('v.isRestore', true);
                        }
                        if (file.name.includes('DELETED_')) {
                            cmp.set('v.isFiles', false);
                        } else {
                            cmp.set('v.isFiles', true);
                        }
                    });
                    cmp.set('v.meta.dto.files', response);
                    cmp.set('v.isBusy', false);
                });
        });
    },

    HandleOneDriveFileDelete: function (cmp, event, helper) {
        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;
        var file = event.getParams().payload.file;
        var files = cmp.get('v.meta.dto.files');
        var newList = [];

        var oneDriveUtils = cmp.find("OneDriveUtils");
        oneDriveUtils.archiveItem(sObjectName, recordName, file.id, file.name, null).then(function (value) {
            files.map(function (item) {
                if (item.id != file.id) {
                    newList.push(item);
                }
            });
            return newList;
        }).then(function (value) {
            debugger
            cmp.set('v.isFiles', false);

            newList.sort(function (a, b) {
                return new Date(b.createdDateTime) - new Date(a.createdDateTime);
            }).map(function (item) {

                if (!file.name.includes('DELETED_')) {
                    cmp.set('v.isFiles', true);
                }
            });
            cmp.set('v.meta.dto.files', newList);
            cmp.set('v.isRestore', true);
        })
    },

    handleRestore: function (cmp, event, helper) {
        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;

        cmp.find('modalService').show(
            'c:OneDriveRestore',
            {
                recordId: cmp.folderName,
                driveId: cmp.driveId,
                sObjectName: sObjectName,
                folderName: recordName
            },
            {
                header: 'Restore or Delete Files',
                cssClass: 'slds-modal_small',
                showCloseButton: true,
                closeCallback: function () {

                    var oneDriveUtils = cmp.find("OneDriveUtils");
                    oneDriveUtils.driveItems(sObjectName, recordName, null).then(function (files) {
                        cmp.set('v.isRestore', false);

                        files.sort(function (a, b) {
                            return new Date(b.createdDateTime) - new Date(a.createdDateTime);
                        }).map(function (file) {
                            if (file.name.includes('DELETED_')) {
                                cmp.set('v.isRestore', true);
                            }
                            if (file.name.includes('DELETED_')) {
                                cmp.set('v.isFiles', false);
                            } else {
                                cmp.set('v.isFiles', true);
                            }
                        });
                        cmp.set('v.meta.dto.files', files);
                        cmp.set('v.isBusy', false);
                    });
                }
            }
        )
    },

    HandleOneDriveDownloadAllFile: function (cmp, event, helper) {
        var file = event.getParams().payload.file;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": file['@microsoft.graph.downloadUrl']
        });
        debugger
        urlEvent.fire();
    },

    HandleFileView: function (cmp, event, helper) {
        var file = event.getParams().payload.file;
        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;


        var oneDriveUtils = cmp.find("OneDriveUtils");
        oneDriveUtils.getLink(sObjectName, recordName, file.id).then(function (value) {
            debugger
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": value.urlToViewFile
            });
            urlEvent.fire();
        });
    }
})