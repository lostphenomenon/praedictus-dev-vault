# Web App Manifest
Make your mobile Web App INSTALLABLE

The manifest is a JSON formatted file which should sit in the application folder (e.g.: public).

To make sure the file is used add the following to each page of your application (that you serve to clients) into the head section:

<link rel="manifest" href="/manifest.json">

Properties of manifest.json:
    - name: long name of our application
    - short_name: name to appear under an icon
    - start_url: which page to load on startup
    - scope: which pages should be included in the PWA
        . means that all the files in the public folder are part of the webapp
    - display: standalone --> we dont see browser features,
        makes it look like a native app
            -standalone
            -minimal-ui
            -fullscreen
            etc.
    - bgcolor: color to display whilst loading and on splashscreen
    - theme_color: controls top bar and task switcher
    - description: eg. used when making site favorite
    - dir (direction): lrt (left-to-right) eg. rtl for Israelis
    - lang: language
    - orientation: enforce default orientation for you application (restricts!)
        -any
        -portrait
        -landscape
    - icons: provide icons here for you application, each machine chooses the best applicable

EXAMPLE:

    {
        "name": "TKApp - Activity Tracker",
        "short_name": "TKApp",
        "start_url": "/index.html",
        "scope": ".",
        "display": "standalone",
        "background_color": "#fff",
        "theme_color": "#3F51B5",
        "description": "Keep calm and carry on!",
        "dir": "ltr",
        "lang": "en-US",
        "orientation": "portrait-primary",
        "icons": [
            {
                "src": "/src/images/icons/app-icon-48x48.png,
                "type": "image/png",
                "sizes": "48x48"                
            },
                        {
                "src": "/src/images/icons/app-icon-96x96.png,
                "type": "image/png",
                "sizes": "96x96"                
            }
        ],
        "related_applications": [
            {
                "platform": "play",
                "url": "https://play.google.com/store/apps/details?id=com.example.app1",
                "id": "com.example.app1"
            }
        ]
    }