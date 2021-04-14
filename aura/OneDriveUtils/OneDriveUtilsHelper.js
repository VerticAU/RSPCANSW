({

    getOverrides: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.execute(payload.cmp, 'vertic_SOQLPRoc',
                {
                    SOQL: 'SELECT DeveloperName, RecordApiName__c, DriveName__c FROM OnedriveSetting__mdt'
                }
            ).then(function (response) {
                var records = response.dto.records || [];
                payload.overrides = new Map();

                if (records.length > 0) {

                    records.forEach(function (record) {
                        payload.overrides.set(record['DriveName__c'], record['RecordApiName__c']);
                    });

                    return resolve(payload);

                } else {
                    return reject([{
                        message: 'Settings not exist'
                    }]);
                }
            }, reject);
        });
    },

    getDrives: function (payload) {
        return new Promise(function (resolve, reject) {
            var siteName = payload.cmp.get('v.siteName');

            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    endpoint: 'callout:OneDrive/sites/rspcansw.sharepoint.com:/sites/' + siteName + ':/drives',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                }
            ).then(function (response) {
                var resp = JSON.parse(response.dto.response);
                var driveIdToSObjectName = new Map();
                var overrides = payload.overrides;

                resp['value'].forEach(function (drive) {
                    var sObjectName = overrides.get(drive['name']);
                    var driveId = drive['id'];
                    if (sObjectName && driveId) {
                        driveIdToSObjectName.set(sObjectName, driveId);
                    }
                });
                payload.cmp.set('v.driveIdToSObjectName', driveIdToSObjectName);

                return resolve(payload);

            }, reject)
        });
    },

    checkFileSizeLimits: function (payload) {
        return new Promise(function (resolve, reject) {

            if (payload.file.size < 50 * 1024 * 1024) {
                var dtoFiles = payload.cmp.get("v.meta.dto.files");
                if (dtoFiles) {
                    var totalSize = payload.file.size;
                    for (var i = 0; i < dtoFiles.length; i++) {
                        totalSize += dtoFiles[i].size;
                    }
                    if (totalSize < 50 * 1024 * 1024) {
                        resolve(payload);
                    } else {
                        reject(new Error("The maximum total files size is 50 MB."));
                    }
                } else {
                    resolve(payload);
                }
            } else {
                payload.helper.showToast(
                    payload.cmp,
                    {
                        message: 'The maximum total files size is 50 MB.',
                        variant: 'warning'
                    }
                );
                reject([{
                    message: 'The maximum total files size is 50 MB.'
                }]);
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

    checkIsExistFolder: function (payload) {
        return new Promise(function (resolve, reject) {

            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    endpoint: 'callout:OneDrive/drives/' + payload.drive + '/root/children/' + encodeURIComponent(payload.folder) + '/children',
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
                    endpoint: 'callout:OneDrive/drives/' + payload.drive + '/root/children/',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        "name": payload.folder,
                        "folder": {},
                        "description": "testDescription",
                        "@microsoft.graph.conflictBehavior": "replace"
                    })
                };

                payload.helper.utils(payload.cmp).execute(payload.cmp, 'vertic_HttpRequestProc', request,

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

    createSession: function (payload) {

        return new Promise(function (resolve, reject) {

            var fileName = payload.file.name;
            if(payload.prefix != null){
                fileName = payload.prefix + payload.file.name;
            }

            var request = {
                endpoint: 'callout:OneDrive/drives/' + payload.drive + '/root:/' + payload.folder + '/' + encodeURIComponent(fileName) + ':/createUploadSession',
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    "item": {
                        "@microsoft.graph.conflictBehavior": "replace"
                    }
                })
            };
            payload.helper.utils(payload.cmp).execute(payload.cmp, 'vertic_HttpRequestProc', request,

                function (response) {

                    var response = JSON.parse(response.dto.response) || [];
                    payload.uploadUrl = response.uploadUrl;

                    payload.helper.readFile(payload).then($A.getCallback(function () {
                        var chunks = payload.helper.getChunks(payload, 1024 * 1024 * 2); // 1024 * 1024 * 2 = 2MB
                        function sequential(arr, index) {
                            index = index || 0;
                            if (index >= arr.length) {
                                return Promise.resolve()
                            }
                            return payload.helper.uploadFile(payload, chunks[index].start, chunks[index].end, chunks[index].blob)
                                .then($A.getCallback(function () {
                                    console.log('file parts' ,chunks[index] )
                                    return sequential(arr, index + 1)
                                }))
                        }
                        sequential(chunks).then($A.getCallback(function () {
                            resolve(payload);
                        }));
                    }, reject));

                }, function (error) {
                    debugger
                })
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
                        console.log('resp ', response)
                        resolve(payload);
                    },

                    function (errors) {
                        reject(errors);
                    })
            }));
        });

    },

    getItems: function (payload) {
        return new Promise(function (resolve, reject) {

            var items = [];
            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    endpoint: 'callout:OneDrive/drives/' + payload.drive + '/root:/' + encodeURIComponent(payload.folder) + ':/children',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                }).then(function (response) {
                var files = JSON.parse(response.dto.response) || [];
                files = files['value'];
                var items = [];

                if (files && files.length > 0) {
                    var isRestore = true;

                    files = files.map(function (file) {

                        file.sizeFormatted = payload.helper.bytesToSize(file.size);
                        items.push(file);

                    });
                    return resolve(items);

                }
                return resolve(items);

            });
        })
    },
    renameItem: function (payload) {
        return new Promise(function (resolve, reject) {

            var body = JSON.stringify({
                "name": payload.name
            });

            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    method: methodsMap.get(optons.get('method')),
                    endpoint: 'callout:OneDrive/drives/' + encodeURIComponent(payload.drive) + '/items/' + encodeURIComponent(payload.file),
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }, body: body
                },
                function (response) {
                    return resolve(response);
                },
                function (errors) {
                    return reject([{
                        message: 'Error'
                    }]);
                }
            )
        })
    },

    getLinkFileView: function (payload) {
        return new Promise(function (resolve, reject) {
            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    method: 'POST',
                    endpoint: 'callout:OneDrive/drives/' + payload.drive + '/items/' + encodeURIComponent(payload.file) + '/preview',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({})
                },
                function (response) {
                    var urlToViewFile = JSON.parse(response.dto.response).getUrl;
                    payload.urlToViewFile = urlToViewFile;
                    debugger
                    resolve(payload);
                },
                function (errors) {
                    reject(errors);
                })
        });
    },



    changeItem: function (payload) {
        return new Promise(function (resolve, reject) {

            var methodsMap = new Map([
                ['Delete', 'DELETE'],
                ['Rename', 'PUT'],
                ['Archive', 'PUT']
            ]);
            var body;
            var optons = payload.options;

            if (optons.get('method') == 'Archive') {
                body = JSON.stringify({
                    "name": "DELETED_" + payload.name
                })
            } else if (optons.get('method') == 'Rename') {
                body = JSON.stringify({
                    "name": payload.name
                })
            }

            payload.helper.execute(payload.cmp, 'vertic_HttpRequestProc',
                {
                    method: methodsMap.get(optons.get('method')),
                    endpoint: 'callout:OneDrive/drives/' + encodeURIComponent(payload.drive) + '/items/' + encodeURIComponent(payload.file),
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }, body: body
                },
                function (response) {
                    return resolve(response);
                },

                function (errors) {
                    return reject([{
                        message: 'Error'
                    }]);
                }
            )
        })
    },

    bytesToSize: function (bytes) {
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        if (bytes == 0) return '0 Byte';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
        return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
    },

    upFile: function (payload) {
        return new Promise(function (resolve, reject) {
            var helper = payload.helper;
            helper.checkFileSizeLimits({
                cmp: payload.cmp,
                helper: payload.helper,
                file: payload.file,
                folder: payload.folder,
                drive: payload.drive,
                prefix: payload.prefix

            })
                .then(helper.readFile)
                .then(helper.checkIsExistFolder)
                .then(helper.createFolder)
                .then(helper.createSession)
                .then(function (value) {
                    return resolve({
                        isSuccess: true
                    })
                })
                .catch(function (errors) {
                    console.log('error', errors);
                    return resolve({
                        isSuccess: false
                    })
                })
        });
    },

    showToast: function (cmp, messageToast) {
        cmp.find('notifLib').showToast(messageToast);
    }
})