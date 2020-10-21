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
                cmp.set('v.meta.dto.files', files);

                files.map(function (file) {

                    if (file.name.includes('DELETED_')) {
                        cmp.set('v.isRestore', true);
                    }
                    if (!file.name.includes('DELETED_')) {
                        cmp.set('v.isFiles', true);

                    }
                });
            }


        }).catch(function (reason) {

        }).finally(function () {
            cmp.set('v.isBusy', false)
            cmp.set('v.isFirst', false)
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
                    cmp.set('v.meta.dto.files', response);

                    response.map(function (file) {
                        if (file.name.includes('DELETED_')) {
                            cmp.set('v.isRestore', true);
                        }
                        if (file.name.includes('DELETED_')) {
                            cmp.set('v.isFiles', false);

                        } else {
                            cmp.set('v.isFiles', true);

                        }
                    });

                    cmp.set('v.isBusy', false);
                });
        })


    },
    // handleFilesChange: function (cmp, event, helper) {
    //     var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
    //     var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;
    //     var files = event.getSource().get("v.files");
    //
    //     cmp.set('v.isBusy', true);
    //     var oneDriveUtils = cmp.find("OneDriveUtils");
    //
    //     oneDriveUtils.upload(files, sObjectName, recordName).then(function (value) {
    //         oneDriveUtils.driveItems(sObjectName, recordName, null)
    //             .then(function (response) {
    //                 cmp.set('v.meta.dto.files', response);
    //
    //                 response.map(function (file) {
    //                     if (file.name.includes('DELETED_')) {
    //                         cmp.set('v.isRestore', true);
    //                     }
    //                     if (file.name.includes('DELETED_')) {
    //                         cmp.set('v.isFiles', false);
    //
    //                     } else {
    //                         cmp.set('v.isFiles', true);
    //
    //                     }
    //                 });
    //
    //                 cmp.set('v.isBusy', false);
    //             });
    //     })
    //
    //
    // },
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
            })
            return newList;
        }).then(function (value) {
            debugger
            cmp.set('v.isFiles', false);
            newList.map(function (item) {

                if (!file.name.includes('DELETED_')) {
                    cmp.set('v.isFiles', true);

                }
            })


            cmp.set('v.meta.dto.files', newList);
            cmp.set('v.isRestore', true);
        })


    },

    handleRestore: function (cmp, event, helper) {
        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;

        var payload = {
            cmp: cmp,
            event: event,
            helper: helper
        }

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
                        cmp.set('v.meta.dto.files', files);
                        cmp.set('v.isRestore', false);
                        files.map(function (file) {
                            if (file.name.includes('DELETED_')) {
                                cmp.set('v.isRestore', true);
                            }
                            if (file.name.includes('DELETED_')) {
                                cmp.set('v.isFiles', false);

                            } else {
                                cmp.set('v.isFiles', true);

                            }
                        });

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

        })


    }
//
//
//         if (event.getSource().get("v.files").length < 0) {
//             return;
//         }

//     handleInit: function (cmp, event, helper) {
//         var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
//         cmp.set('v.isBusy', true);
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper
//         };
//         debugger;
//         helper.getDriveMapping(payload)
//             .then($A.getCallback(helper.init))
//             .then($A.getCallback(helper.refresh2))
//             .catch(function (ex) {
//                 console.error(ex.errors);
//                 helper.handleShowToast(cmp, {
//                     message: ex.errors[0].message
//                 });
//                 cmp.set('v.isBusy', false);
//             });
//     },
//
//     handleRestore: function (cmp, event, helper) {
//
//
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper
//         }
//         var files = cmp.get('v.meta.dto.files');
//         console.log('files  ', files)
//         cmp.find('modalService').show(
//             'c:OneDriveRestore',
//             {
//                 files: files,
//                 recordId: cmp.folderName,
//                 driveId: cmp.driveId
//             },
//             {
//                 header: 'Restore or Delete Files',
//                 cssClass: 'slds-modal_small'
//
//             }
//         ).then(function (action) {
//                 // if (action != null && action.action === 'true') {
//                 cmp.set('v.isBusy', true);
//
//                 helper.refresh2(payload)
//                     .then(function (value) {
//
//                     })
//                     .catch(function (reason) {
//                         cmp.set('v.isBusy', false);
//                     })
//             }//}
//         )
//
//
//     },
//
//     handleFilesChange: function (cmp, event, helper) {
//
//
//         if (event.getSource().get("v.files").length < 0) {
//             return;
//         }
//         var objectName = cmp.get('v.objectName');
//         var folderName = cmp.get('v.recordName') ? cmp.get('v.recordName') :
//             (cmp.folderName ? cmp.folderName : 'TEMP_' + helper.utils(cmp).getRandomString(10));
//         cmp.folderName = folderName;
//         // cmp.folderName = objectName + '\u002F' + folderName;
//         debugger
//
//         var files = event.getSource().get("v.files");
//         for(var i=0; i< files.length; i++ ){
//             var payload = {
//                 cmp: cmp,
//                 event: event,
//                 helper: helper,
//                 file: files[i],
//                 folderName: cmp.folderName
//             };
//
//             cmp.set('v.isBusy', true);
//             helper.checkFileSizeLimits(payload)
//                 .then($A.getCallback(helper.readFile))
//                 .then($A.getCallback(helper.checkIsExistFolder))
//                 .then($A.getCallback(helper.createFolder))
//                 .then($A.getCallback(helper.createSession))
//                 .then($A.getCallback(helper.refresh2))
//                 .then($A.getCallback(function () {
//                     cmp.set('v.isBusy', false);
//                 }))
//                 .catch(function (ex) {
//                     var message = ex && ex.message ? ex.message : ex.errors[0].message;
//                     helper.handleShowToast(cmp, {
//                         message: message
//                     });
//
//                     cmp.set('v.isBusy', false);
//                 });
//         }
//
//     },
//
//     HandleOneDriveUpdateFolder: function (cmp, event, helper) {
//         var objectName = cmp.get('v.objectName');
//         var folderName = event.getParam('arguments').recordName;
//         var newPath = objectName + '\u002F' + folderName;
//
//
//         debugger
//         if (cmp.get("v.meta.dto.files")) {
//             var payload = {
//                 cmp: cmp,
//                 event: event,
//                 helper: helper,
//                 folderName: cmp.get('v.objectName')
//                 // folderName: event.getParam('arguments').recordName
//                 // folderName: newPath
//             }
//
//
//             cmp.set('v.isBusy', true);
//             helper.updateFolder(payload)
//                 .then($A.getCallback(function () {
//                         cmp.set('v.isBusy', false);
//                         helper.utils(cmp).showSuccess(cmp, 'Record has been created successfully');
//                         window.location = "/" + event.getParam('arguments').recordName;
//                     },
//
//                     function (ex) {
//                         console.error(ex.errors);
//                         helper.handleShowToast(cmp, {
//                             message: ex.errors[0].message
//                         });
//                         cmp.set('v.isBusy', false);
//                     }));
//         } else {
//             helper.utils(cmp).showSuccess(cmp, 'Record has been created successfully');
//             window.location = "/" + event.getParam('arguments').recordName;
//         }
//     },
//
//     HandleOneDriveFileRemove: function (cmp, event, helper) {
//         debugger
//         var objectName = cmp.get('v.objectName');
//         var folderName = cmp.get('v.recordName') ? cmp.get('v.recordName') :
//             (cmp.folderName ? cmp.folderName : 'TEMP_' + helper.utils(cmp).getRandomString(10));
//         // var path = objectName + '\u002F' + folderName;
//
//
//         console.log('remove')
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             deleteUrl: event.getParams().payload.file.name,
//             deleteId: event.getParams().payload.file.id,
//             // folderName: cmp.get('v.objectName')
//
//         folderName: cmp.get('v.recordName')
//         // folderName: path
//
//         }
//
//         var file = event.getParams().payload.file;
//         delete
//             cmp.find('modalService').show(
//                 'c:OneDriveFileDeleteConfirmation',
//                 {
//                     file: file
//                 },
//                 {
//                     header: 'Confirmation',
//                     cssClass: 'slds-modal_small'
//                 }
//             ).then(function (file) {
//                 cmp.set('v.isBusy', true);
//
//                 helper.delete(payload)
//                     .then(helper.refresh(payload.cmp, payload.event, payload.helper))
//                     .then(function (value) {
//
//                     })
//                     .catch(function (reason) {
//                         cmp.set('v.isBusy', false);
//                     });
//
//             }, function (ex) {
//                 console.error(ex.errors);
//                 helper.handleShowToast(cmp, {
//                     message: ex.errors[0].message
//                 });
//                 cmp.set('v.isBusy', false);
//             });
//
//     },
//     HandleOneDriveFileDelete: function (cmp, event, helper) {
// debugger
//         var objectName = cmp.get('v.objectName');
//         var folderName = cmp.get('v.recordName') ? cmp.get('v.recordName') :
//             (cmp.folderName ? cmp.folderName : 'TEMP_' + helper.utils(cmp).getRandomString(10));
//         // var path = objectName + '\u002F' + folderName;
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             deleteUrl: event.getParams().payload.file.name,
//             deleteId: event.getParams().payload.file.id,
//             // folderName: cmp.get('v.objectName')
//             folderName: cmp.get('v.recordName')
//             // folderName: path
//
//         }
//
//         var file = event.getParams().payload.file;
//         delete
//             helper.delete(payload)
//                 .then(function (file) {
//                     cmp.set('v.isBusy', true);
//
//                     helper.delete(payload)
//                         .then(helper.refresh(payload.cmp, payload.event, payload.helper))
//                         .then(function (value) {
//
//                         })
//                         .catch(function (reason) {
//                             cmp.set('v.isBusy', false);
//                         });
//
//                 }, function (ex) {
//                     console.error(ex.errors);
//                     helper.handleShowToast(cmp, {
//                         message: ex.errors[0].message
//                     });
//                     cmp.set('v.isBusy', false);
//                 });
//
//     },
//
//
//
//
//     HandleOneDriveFileDownloadLink: function (cmp, event, helper) {
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             fileId: event.getParams().payload.file.id
//
//         };
//
//         helper.getDownloadLink(payload)
//             .then($A.getCallback(function (payload) {
//
//                     cmp.find('modalService').show(
//                         'c:OneDriveFileDownload',
//                         {
//                             payload: payload
//                         },
//                         {
//                             header: 'Download',
//                             cssClass: 'slds-modal_small'
//                         }
//                     )
//                 },
//
//                 function (ex) {
//                     console.error(ex.errors);
//                     helper.handleShowToast(cmp, {
//                         message: ex.errors[0].message
//                     });
//                     cmp.set('v.isBusy', false);
//                 }))
//     },
//
//
//     HandleOneDriveDownloadAllFile: function (cmp, event, helper) {
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             fileId: event.getParams().payload.file.id
//         };
//
//         helper.getDownloadFile(payload)
//             .then($A.getCallback(function () {
//
//                     // var win = window.open(payload.downloadLink, '_blank');
//                     // win.focus();
//
//                     // var urlEvent = $A.get("e.force:navigateToURL");
//                     // urlEvent.setParams({
//                     //     "url": payload.downloadLink
//                     // });
//                     // urlEvent.fire();
//
//                     cmp.find('modalService').show(
//                         'c:OneDriveFileDownload',
//                         {
//                             payload: payload
//                         },
//                         {
//                             header: 'Download',
//                             cssClass: 'slds-modal_small'
//                         }
//                     );
//                 },
//                 function (ex) {
//                     console.error(ex.errors);
//                     helper.handleShowToast(cmp, {
//                         message: ex.errors[0].message
//                     });
//                     cmp.set('v.isBusy', false);
//                 }))
//     },
//
//     HandleFileView: function (cmp, event, helper) {
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             fileId: event.getParams().payload.file.id
//
//         }
//         helper.getLinkFileView(payload)
//             .then($A.getCallback(function () {
//
//                     cmp.find('modalService').show(
//                         'c:OneDriveFileView',
//                         {
//                             payload: payload
//                         },
//                         {
//                             header: 'Preview',
//                             cssClass: 'slds-modal_small'
//                         }
//                     )
//                 },
//
//                 function (ex) {
//                     console.error(ex.errors);
//                     helper.handleShowToast(cmp, {
//                         message: ex.errors[0].message
//                     });
//                     cmp.set('v.isBusy', false);
//                 }))
//     },
//
//
//     HandleSendEmail: function (cmp, event, helper) {
//         cmp.set('v.isBusy', true);
//
//         var payload = {
//             cmp: cmp,
//             event: event,
//             helper: helper,
//             fileId: event.getParams().payload.file.id
//
//         }
//
//         var actionAPI = cmp.find("quickActionAPI");
//         helper.getDownloadFile(payload)
//         //.then(actionAPI.getAvailableActionFields({actionName: "SendEmail"})
//             .then(function (response) {
//
//                 var targetFields = {
//                     HtmlBody: {value: "link:  <a href=" + payload.downloadLink + ">DOWNLOAD</a> "},
//                     Subject: {value: "link to download"}
//                 };
//
//                 var args = {
//                     actionName: "SendEmail",
//                     targetFields: targetFields
//                 };
//
//                 actionAPI.setActionFieldValues(args).then(function () {
//                     // actionAPI.invokeAction(args);
//
//                     cmp.set('v.isBusy', false);
//                     helper.handleShowToast(cmp, {
//                         message: 'Please complete fields on email activity'
//                     });
//
//                 }).catch(function (ex) {
//                     console.error(ex.errors);
//                     helper.handleShowToast(cmp, {
//                         message: ex.errors[0].message
//                     });
//                     cmp.set('v.isBusy', false);
//
//                 });
//
//
//             }, function (ex) {
//                 console.error(ex.errors);
//                 helper.handleShowToast(cmp, {
//                     message: ex.errors[0].message
//                 });
//                 cmp.set('v.isBusy', false);
//
//             });
//     },
//


})