({

    isRestoreExist: function(files){
        files = files.map(function (file) {

        });
    },


    init: function (payload) {
        return new Promise(function (resolve, reject) {

            var folderName = payload.cmp.get('v.recordName') ? payload.cmp.get('v.recordName') : null;
            var objectName = payload.cmp.get('v.objectName') ? payload.cmp.get('v.objectName') : null;
            var siteName = 'SalesForceDocInt';

            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    endpoint: 'callout:OneDrive/sites/rspcansw.sharepoint.com:/sites/' + siteName + ':/drives',
                   headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                },
                function (response) {
                    var resp = JSON.parse(response.dto.response);
                    var driveMap = new Map();
                    debugger

                    resp['value'].forEach(function(drive){
                        driveMap.set( drive['name'] , drive['id'] );
                    } );

                    if(!driveMap.has(objectName)){
                        debugger
                        payload.cmp.set('v.hideContentOnBusy', true);
                        payload.cmp.set('v.isBusy', true);
                        helper.handleShowToast(payload.cmp, {
                            message: objectName + ' did\'t set for SharePoint integration'
                        });
                    }

                    payload.cmp.driveId =  driveMap.get(objectName);
                    payload.cmp.folderName =  folderName;

                    payload.isFolderExists = resp.error == undefined; // TODO: check error;
                    resolve(payload);

                },
                function (errors) {
                    reject(errors);
                })



            // var actionAPI = payload.cmp.find("quickActionAPI");
                // actionAPI.getAvailableActions()
                //     .then($A.getCallback(function (response) {
                //         if (JSON.stringify(response.actions).includes('SendEmail')) {
                            payload.cmp.set('v.meta.dto.isButtonEmail', true);
                        // }


                    // }));
            });
            // ,
            // function (errors) {
            //     reject(errors);
            // })

    },

    getDriveMapping : function (payload){

        return new Promise(function (resolve, reject) {
            var sObjectName = payload.cmp.get('v.sObjectName') ? payload.cmp.get('v.sObjectName') : null;
            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_SOQLProc',
                {
                    SOQL: 'SELECT DeveloperName, RecordApiName__c, DriveName__c FROM OnedriveSetting__mdt WHERE RecordApiName__c  = \'' + sObjectName + '\''
                }, function (response) {
                    var records = response.dto.records || [];
                    if (records.length > 0) {

                        payload.cmp.set('v.objectName', records[0]['DriveName__c']);
                        debugger
                        resolve(payload);

                    } else {
                        debugger
                        reject(errors);

                    }
                },function (error) {
                    debugger
                }
            )
        })
    },

    checkIsExistFolder: function (payload) {
        return new Promise(function (resolve, reject) {

            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId  + '/root/children/' + encodeURIComponent(payload.folderName) + '/children',
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId  + '/root/children/' + encodeURIComponent(payload.folderName) + '/children',
                    // endpoint: 'callout:OneDrive/me/drive/root/children/' + encodeURIComponent(payload.folderName) + '/children',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                },
                function (response) {
                    var resp = JSON.parse(response.dto.response);
                    payload.isFolderExists = resp.error == undefined; // TODO: check error;
                    resolve(payload);
                },
                function (errors) {
                    reject(errors);
                })
        });
    },

    createFolder: function (payload) {

        return new Promise(function (resolve, reject) {

            if (payload.isFolderExists != true) {
                var request = {
                    // endpoint: 'callout:OneDrive/sites/'+payload.cmp.siteId +'/drives/'+ payload.cmp.object+'/root/children/',
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/root/children/',
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/root/children/',
                    // endpoint: 'callout:OneDrive/me/drive/root/children/',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        "name": payload.folderName,
                        "folder": {},
                        "description": "testDescription",
                        "@microsoft.graph.conflictBehavior": "rename"
                    })
                };

                payload.helper.utils(payload.cmp).execute(
                    payload.cmp,
                    'vertic_HttpRequestProc',
                    request,

                    function (response) {
                        var resp = JSON.parse(response.dto.response);
                        payload.cmp.folderId = resp.id ? resp.id : null;
                        resolve(payload);
                    },

                    function (errors) {
                        reject(errors);
                    })
            }
            else {
                resolve(payload);
            }
        });

    },

    updateFolder: function (payload) {
        return new Promise(function (resolve, reject) {
            var request = {
                endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/items/' + payload.cmp.folderId,
                // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/items/' + payload.cmp.folderId,
                // endpoint: 'callout:OneDrive/me/drive/items/' + payload.cmp.folderId,
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    "name": payload.folderName,
                })
            };

            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                request,

                function (response) {
                    resolve(payload);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },

    createSession: function (payload) {

        return new Promise(function (resolve, reject) {
            var request = {
                endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/root:/' + encodeURIComponent(payload.folderName) + '/' + encodeURIComponent(payload.file.name) + ':/createUploadSession',
                // endpoint: 'callout:OneDrive/me/drive/root:/' + encodeURIComponent(payload.folderName) + '/' + encodeURIComponent(payload.file.name) + ':/createUploadSession',
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    "item": {
                        "@microsoft.graph.conflictBehavior": "rename"
                    }
                })
            };

            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                request,

                function (response) {

                    var sessionObj = JSON.parse(response.dto.response) || [];
                    payload.uploadUrl = sessionObj.uploadUrl;
                        console.log('response ' , sessionObj);
                    payload.helper.readFile(payload).then($A.getCallback(function () {
                        var chunks = payload.helper.getChunks(payload, 1024 * 1024 * 2); // 1024 * 1024 * 2 = 2MB
                        function sequential(arr, index) {
                            index = index || 0;
                            if (index >= arr.length) {
                                return Promise.resolve()
                            }
                            return payload.helper.uploadFile(payload, chunks[index].start, chunks[index].end, chunks[index].blob)
                                .then($A.getCallback(function () {
                                    return sequential(arr, index + 1)
                                }))
                        }

                        sequential(chunks).then($A.getCallback(function () {
                            resolve(payload);
                        }));
                    }, reject))

                }, reject)
        });

    },

    getChunks: function (payload, chunkSize) {

        var arrayVar = new Uint8Array(payload.arrayBuffer);

        var size = arrayVar.length;
        var chunks = [];
        var countOfChunks = Math.ceil(size / chunkSize);

        for (var i = 0; i < countOfChunks; i++) {
            var start = i * chunkSize;
            var end = Math.min(start + chunkSize, size);
            chunks.push({
                start: start,
                end: end,
                blob: new Blob([arrayVar.slice(start, end)])
            });
        }
        return (chunks);
    },


    blobToDataUrl: function (blob) {
        return new Promise(function (resolve, reject) {

            var reader = new FileReader();
            reader.onload = function () {
                var fileContents = reader.result;
                var base64Mark = 'base64,';
                if (fileContents.indexOf(base64Mark) != -1) {
                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                    fileContents = fileContents.substring(dataStart);
                }
                resolve(fileContents);
            };
            reader.readAsDataURL(blob);
        });

    },

    uploadFile: function (payload, startSize, endSize, blob) {
        return new Promise(function (resolve, reject) {
            payload.helper.blobToDataUrl(blob).then($A.getCallback(function (dataUrl) {
                var contentSize = payload.arrayBuffer.byteLength;
                var endpoint = payload.uploadUrl;

                var request = {
                    endpoint: endpoint,
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/octet-stream',
                        'Accept': 'application/json',
                        'Content-Length': (endSize - startSize),
                        'Content-Range': 'bytes ' + (startSize) + '-' + (endSize - 1) + '/' + contentSize
                    },
                    base64Encoded: encodeURIComponent(dataUrl)
                };

                payload.helper.utils(payload.cmp).execute(
                    payload.cmp,
                    'vertic_HttpRequestProc',
                    request,

                    function (response) {
                        resolve(payload);
                    },

                    function (errors) {
                        reject(errors);
                    })
            }));
        });

    },

    checkFileSizeLimits: function (payload) {
        return new Promise(function (resolve, reject) {
            if (payload.file.size < 3 * 1024 * 1024) {
                var dtoFiles = payload.cmp.get("v.meta.dto.files");
                if (dtoFiles) {
                    var totalSize = payload.file.size;
                    for (var i = 0; i < dtoFiles.length; i++) {
                        totalSize += dtoFiles[i].size;
                    }
                    if (totalSize < 20 * 1024 * 1024) {
                        resolve(payload);
                    } else {
                        reject(new Error("The maximum total files size is 20 MB."));
                    }
                } else {
                    resolve(payload);
                }
            } else {
                reject(new Error("The maximum file size is 3 MB."));
            }
        });
    },

    readFile: function (payload) {

        return new Promise(function (resolve, reject) {
            var reader = new FileReader();

            reader.onload = $A.getCallback(function () {
                payload.arrayBuffer = reader.result;
                resolve(payload);
            });
            reader.onerror = $A.getCallback(function (errors) {
                reject(errors);
            });

            reader.readAsArrayBuffer(payload.file);     
        });
    },

    refresh2: function (payload) {
        return payload.helper.refresh(payload.cmp, payload.event, payload.helper);
    },

    refresh: function (cmp, event, helper) {
        return new Promise(function (resolve, reject) {
            helper.utils(cmp).execute(
                cmp,
                'vertic_HttpRequestProc',
                {
                    // endpoint: 'callout:OneDrive/me/drive/root/children/' + encodeURIComponent(cmp.folderName) + '/children',
                    // endpoint: 'callout:OneDrive/me/drive/root:/Contacts/C002242:/children',
                     endpoint: 'callout:OneDrive/drives/' + cmp.driveId + '/root:/' + encodeURIComponent(cmp.folderName) + ':/children',
                     // endpoint: 'callout:OneDrive/sites/' + cmp.siteId + '/drives/' + cmp.driveId + '/root:/' + encodeURIComponent(cmp.folderName) + ':/children',
                    // endpoint: 'callout:OneDrive/me/drive/root:/' + encodeURIComponent(cmp.folderName) + ':/children',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                },

                function (response) {
                    debugger
                    var files = JSON.parse(response.dto.response).value || [];
                    var isRestore = true;
                    files = files.map(function (file) {

                        file.sizeFormatted = helper.bytesToSize(file.size);

                        if (cmp.get('v.meta.dto.isButtonEmail')) {
                            file.isButtonEmail = true;
                        } else {
                            file.isButtonEmail = false;
                        }
                       if(file.name.includes('DELETED_')){
                           isRestore = false;
                       }

                        return file;
                    });
                    cmp.set('v.isRestore', isRestore);
                    cmp.set('v.meta.dto.files', files);
                    cmp.set('v.isBusy', false);

                    resolve(response);
                },

                function (errors) {
                    reject(errors);
                })
        })
    },

    delete: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    method: 'PUT',
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.deleteId) ,
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.deleteId) ,
                    // endpoint: 'callout:OneDrive/me/drive/items/' + encodeURIComponent(payload.deleteId) ,
                    headers: {
                        // 'X-HTTP-Method-Override':'PATCH',
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }, body: JSON.stringify({

                        "name": "DELETED_" + payload.deleteUrl

                    })
                },
                function (response) {
                    console.log('response ',response);
                    resolve(response);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },
    /*delete: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    method: 'DELETE',
                    endpoint: 'callout:OneDrive/me/drive/root:/' + encodeURIComponent(payload.folderName) + '/' + encodeURIComponent(payload.deleteUrl),
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                },
                function (response) {
                    resolve(response);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },*/


    getDownloadLink: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    method: 'POST',
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/createLink',
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/createLink',
                    // endpoint: 'callout:OneDrive/me/drive/items/' + encodeURIComponent(payload.fileId) + '/createLink',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({"type": "view", "scope": "anonymous"})
                },

                function (response) {
                    payload.downloadLink = JSON.parse(response.dto.response).link.webUrl;
                    resolve(payload);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },


    getDownloadFile: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    method: 'GET',
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/content',
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/content',
                    // endpoint: 'callout:OneDrive/me/drive/items/' + encodeURIComponent(payload.fileId) + '/content',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                },

                function (response) {
                    payload.downloadLink = response.dto.headers.Location;
                    resolve(payload);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },

    getLinkFileView: function (payload) {
        return new Promise(function (resolve, reject) {

            payload.helper.utils(payload.cmp).execute(
                payload.cmp,
                'vertic_HttpRequestProc',
                {
                    method: 'POST',
                    endpoint: 'callout:OneDrive/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/preview',
                    // endpoint: 'callout:OneDrive/sites/' + payload.cmp.siteId + '/drives/' + payload.cmp.driveId + '/items/' + encodeURIComponent(payload.fileId) + '/preview',
                    // endpoint: 'callout:OneDrive/me/drive/items/' + encodeURIComponent(payload.fileId) + '/preview',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({})
                },
                function (response) {
                    var urlToViewFile = JSON.parse(response.dto.response).getUrl;

                    payload.urlToViewFile = urlToViewFile;
                    resolve(payload);
                },

                function (errors) {
                    reject(errors);
                })
        });
    },


    // getStartDownloadFile: function (payload) {
    //     return new Promise(function (resolve, reject) {
    //             var chunks = payload.helper.getChunksForDownload(payload, 1024 * 1024 * 2); // 1024 * 1024 * 2 = 2MB
    //
    //             function sequential(arr, index) {
    //                 index = index || 0;
    //                 if (index >= arr.length) {
    //                     debugger
    //                     return Promise.resolve()
    //                 }
    //                 debugger
    //                 return ($A.getCallback(payload.helper.getContentFileFromOneDrive(payload, chunks[index].start, chunks[index].end, chunks[index].blob)
    //                     .then($A.getCallback(function () {
    //                         debugger
    //                         return sequential(arr, index + 1)
    //                     }))))
    //             }
    //
    //             sequential(chunks).then($A.getCallback(function () {
    //                 debugger
    //                 resolve(payload);
    //             }));
    //         },
    //
    //         function (errors) {
    //             reject(errors);
    //         })
    //
    // },

    // getContentFileFromOneDrive: function (payload, startSize, endSize, blob) {
    //     return new Promise(function (resolve, reject) {
    //
    //         var contentSize = payload.file.size;
    //         debugger
    //         var request = {
    //             endpoint: payload.downloadLink,
    //             method: 'GET',
    //             headers: {
    //                 'Content-Type': 'application/octet-stream',
    //                 'Accept': 'application/json',
    //                 'Range': 'bytes=' + (startSize) + '-' + (endSize - 1)
    //             },
    //         };
    //
    //         payload.helper.utils(payload.cmp).execute(
    //             payload.cmp,
    //             'vertic_HttpRequestProc',
    //             request,
    //
    //             function (response) {
    //                 debugger
    //                 payload.blobFile += response.dto.response;
    //                 resolve(payload);
    //             },
    //
    //             function (errors) {
    //                 debugger
    //                 reject(errors);
    //             })
    //     });
    //
    // },

    // attachFileToEmail: function (payload, blob) {
    //     return new Promise(function (resolve, reject) {
    //
    //         debugger
    //
    //         var actionAPI = cmp.find("quickActionAPI");
    //         var targetFields = {
    //             HtmlBody: {value: "link: " + payload.downloadLink},
    //             Subject: {value: "link to download"},
    //             ContentDocumentIds: {value: payload.blobFile}
    //         };
    //
    //         var args = {
    //             actionName: "SendEmail",
    //             targetFields: targetFields
    //         };
    //
    //         actionAPI.setActionFieldValues(args).then(function () {
    //             resolve(payload);
    //         }).catch(function (e) {
    //             console.error(e.errors);
    //             reject(e.errors);
    //
    //         });
    //
    //     })
    // },

    // getChunksForDownload: function (payload, chunkSize) {
    //     var chunks = [];
    //     var countOfChunks = Math.ceil(payload.file.size / chunkSize);
    //
    //     for (var i = 0; i < countOfChunks; i++) {
    //         var start = i * chunkSize;
    //         var end = Math.min(start + chunkSize, payload.file.size);
    //         chunks.push({
    //             start: start,
    //             end: end
    //         });
    //     }
    //     return (chunks);
    // },


    bytesToSize: function (bytes) {
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        if (bytes == 0) return '0 Byte';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
        return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
    },


    handleShowToast: function (cmp, messageToast) {
        cmp.find('notifLib').showToast(messageToast);
    }


})