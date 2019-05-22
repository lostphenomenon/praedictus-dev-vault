// Scripts to process html received from MVC controller endpoint, including script tags
// the point is to trigger script execution thus "widgetizing" the embedded page
// toolkit.GetRequest == standard XmlHttpRequest

function fixScriptsSoTheyAreExecuted(el) {
    var scripts = el.querySelectorAll('script'),
        script, fixedScript, i, len;

    for (i = 0, len = scripts.length; i < len; i++) {
        script = scripts[i];

        fixedScript = document.createElement('script');
        fixedScript.type = script.type;
        if (script.innerHTML) fixedScript.innerHTML = script.innerHTML;
        else fixedScript.src = script.src;
        fixedScript.async = false;

        script.parentNode.replaceChild(fixedScript, script);
    }
}

// Parsing html from xhr response
function parsePartialHtml(html) {
    var doc = new DOMParser().parseFromString(html, 'text/html'),
        frag = document.createDocumentFragment(),
        childNodes = doc.body.childNodes;

    while (childNodes.length) frag.appendChild(childNodes[0]);

    return frag;
}

initProfile = function() {
    // Requesting the raw html of a legacy profile
    toolkit.GetRequest(configuration.LegacyProfileUrl,
        function(xhr) {
            var html_raw = xhr.responseText;
            if (html_raw) {
                var parsed = parsePartialHtml(html_raw);
                fixScriptsSoTheyAreExecuted(parsed);
                document.getElementById('profile-container').appendChild(parsed);
            } else {
                throw new Error("Request was unsuccessfull-");
            }
        },
        function(err) {
            throw new Error("Cannot retrieve profile.");
        }, {}
    );
}

var bootstrapPage = new function(onSuccess) {

    toolkit.GetRequest(configuration.BaseUrl + '/api/configuration/GetProfilesBootupConfigurationForSpecificClient?clientCode=' + configuration.clientCode,
        function(xhr) {
            var conf = JSON.parse(xhr.responseText);
            if (conf) {
                dealogic.usageTracking.APIV2.setup(
                    configuration.UsageTrackingUrl,
                    configuration.clientCode,
                    conf.UsageTracking.UserGuid,
                    conf.UsageTracking.ImpersonatedUserGuid,
                    conf.UsageTracking.IsDealogicUser,
                    'Hosted - ' + configuration.sourceName,
                    conf.UsageTracking.EnvironmentType,
                    'large',
                    null,
                    '@ViewBag.CorrelationId'
                );
            } else {
                throw new Error('Could not retrieve configuration for client' + configuration.clientCode);
            }
        },
        function() {}, { 'accept': 'application/json' }
    );

    onSuccess();
}(initProfile);