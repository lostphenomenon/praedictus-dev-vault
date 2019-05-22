            /*
                    This snippet enables you to open a link in a separate window in javascript
                    and also allows to specify the properties of this new window. (width, height, location etc.)
            */
            
            self.openInExternalWindow = function (url, options) {
                if (url) {
                    var features = undefined;
                    if (!!options && options.popup === true) {
                        features = 'width=1024px,height=768px,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes';
                        if (!!window.outerWidth && !!window.outerHeight) {
                             // You can specify the location etc via the features passed in the third argument
                            features = features + ',top=' + Math.ceil(window.outerHeight / 2 - 768 / 2 + 50) + ',left=' + Math.ceil(window.outerWidth / 2 - 1024 / 2);
                        }
                    }
                    var win = window.open(url, '_blank', features);
                    if (win == null) {
                        alert('Please enable pop-ups in your browser settings');
                    }
                }
            };