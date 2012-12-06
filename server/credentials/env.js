var credentials = {
    'host': '127.0.0.1', // Where the app will be running
    // MYSQL standard stuff
    'mysql': {
                'host'     : 'localhost',
                'user'     : 'root',
                'password' : '',
                'database' : ''
        },
        // Get this from http://dev.twitter.com
        'twitter': {
                'consumer_key': '_____________',
                'consumer_secret': '_____________',
                'access_token_key': '_____________',
                'access_token_secret': '_____________'
        },
        // Sign up at http://api.instagram.com
        'instagram': {
                'client_id': '_____________',
                'client_secret': '_____________',
                'callback_url': 'http://hostname-from-above/instagram' // Should end in "/instagram", so the service gets a pingback
        },
        'tags': ['#love', '#instrumentoutpost'], // Here are the tags you're looking out for, the heart of why you're here.
        'username': '',   // Fill these out if you want your management area
        'password': ''    // to be password protected. Or not. Your call, really.
};

module.exports = credentials;