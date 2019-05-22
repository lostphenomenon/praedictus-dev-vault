            self.copyToClipboard = function() {
                var helper = document.createElement("input"),
                    url = sharingLink();

                document.body.appendChild(helper);
                helper.setAttribute('value', url);
                helper.select();
                document.execCommand("copy");
                document.body.removeChild(helper);
                self.isShareContextMenuVisible(false);
            };