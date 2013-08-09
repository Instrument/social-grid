var credentials = {
    'host': '127.0.0.1', // Where the app will be running
    // MYSQL standard stuff
    'mysql': {
            'host'     : 'localhost',
            'user'     : 'socialgrid',
            'password' : 'foo',
            'database' : 'socialgrid'
    },
    // Get this from http://dev.twitter.com
    'twitter': {
            'consumer_key': '',
            'consumer_secret': '',
            'access_token_key': '',
            'access_token_secret': ''
    },
    // Sign up at http://api.instagram.com
    'instagram': {
            'client_id': '_____________',
            'client_secret': '_____________',
            'callback_url': 'http://hostname-from-above/instagram' // Should end in "/instagram", so the service gets a pingback
    },
    'google_plus': {
        'api_key': ""
    },
    'tags': ['#bananas'], // Here are the tags you're looking out for, the heart of why you're here.
    'username': 'banana',   // Fill these out if you want your management area
    'password': 'jones',    // to be password protected. Or not. Your call, really.
    'upload_directory': '/Applications/SocialGrid.app/Contents/Resources/resources/photobooth'
};

module.exports = credentials;