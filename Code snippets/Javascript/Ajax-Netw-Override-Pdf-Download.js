if ('cwt' in window) {
    if ($) {
        $.ajaxTransport("+*", function(options, originalOptions, jqXHR, headers, completeCallback) {
            var url = options.url,
                method = options.type,
                data = options.data;
            var handler = null;
            return {
                send: function(headers, completeCallback) {
                    if (method === "POST" && !!data && !!headers["Content-Type"]) {
                        delete headers["Content-Type"];
                    }

                    handler = cwt.networking.Request(url,
                        function(xhr) {
                            completeCallback(xhr.status, xhr.status < 300 ? "success" : "error", {
                                text: xhr.responseText
                            });
                        },
                        function(xhr) {
                            completeCallback(xhr.status, "error", null);
                        }, method, method === "POST" ? JSON.parse(data) : null, headers
                    );
                },
                abort: function() {
                    if (handler != null) handler.abort();
                }
            }
        });
    }

    //IE Compatibility
    if (!window.location.origin) {
        window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
    }
    var toolkit = cwt.APIV1('Cortex.Profiles.UI');

    var addImpersonationToken = function(xhr, url, requestType, onSuccessCallback) {
        var xhr = xhr,
            onSuccessCallback = onSuccessCallback;
        var token = (function(window) {
            var token = null;
            if ('localStorage' in window) {
                token = localStorage.getItem('ImpersonationToken');
            }
            return token;
        })(window);
        if (token !== null) {
            xhr.setRequestHeader('ImpersonationToken', token);
        }

        if (typeof onSuccessCallback === 'function') {
            onSuccessCallback();
        }
    };

    toolkit.onBeforeSend(addImpersonationToken);

    var pdfDownload = document.getElementById('printToPdfLink');
    var pdfLink = document.getElementById('printToPdfUrl');
    var downloadIndicatorElement = document.getElementById('ProfileHeader');
    if (pdfDownload !== undefined && pdfDownload !== null && pdfLink !== undefined && pdfLink !== null) {
        pdfDownload.onclick = function() {
            var url = pdfLink.innerHTML;

            if (downloadIndicatorElement !== null) {
                downloadIndicatorElement.classList.add('k-loading-image');
            }

            pdfDownload.style.display = 'none';
            toolkit.GetRequest(url,
                function(xhr) {
                    // The pdf in the response must be encoded in Base64 for each character in the bytearray to avoid
                    // "byte shaving" and decoded on the client side, thus it can be rendered properly (without blank pages and color scheme issue)
                    // https://stackoverflow.com/questions/51981473/downloaded-pdf-looks-empty-although-it-contains-some-data
                    var binaryString = window.atob(xhr.responseText);
                    var binaryLen = binaryString.length;
                    var bytes = new Uint8Array(binaryLen);
                    for (var i = 0; i < binaryLen; i++) {
                        var ascii = binaryString.charCodeAt(i);
                        bytes[i] = ascii;
                    }

                    // Then it has to be converted to a blob to be able to create and object url and download it 
                    // https://stackoverflow.com/questions/34586671/download-pdf-file-using-jquery-ajax
                    var blob = new Blob([bytes], { type: 'application/pdf' });
                    //In IE it is necessary to use msSaveOrOpenBlob
                    if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                        window.navigator.msSaveOrOpenBlob(blob);
                        return;
                    }
                    var url = window.URL.createObjectURL(blob);
                    var a = document.createElement('a');
                    a.href = url;

                    var profileType = "Dealogic";
                    var profileSubject = "print";

                    var companyName = document.getElementById('CompanyName');
                    if (companyName !== null) {
                        profileSubject = companyName.innerText;
                        profileType = "CompanyProfile";
                    }
                    var investorName = document.getElementById('InstitutionName');
                    if (investorName !== null) {
                        profileSubject = investorName.innerText;
                        profileType = "InvestorProfile";
                    }

                    a.download = "Dealogic_" + profileType + "_" + profileSubject + ".pdf";
                    a.click();

                    if (downloadIndicatorElement !== null) {
                        downloadIndicatorElement.classList.remove('k-loading-image');
                    }

                    setTimeout(function() {
                        // For Firefox it is necessary to delay revoking the ObjectURL
                        window.URL.revokeObjectURL(url);
                    }, 100);

                    pdfDownload.style.display = 'inline';
                },
                function() {
                    throw new Error('Could not retrieve pdf');
                }, { 'Accept': 'application/pdf' }
            );
        };
    }
}