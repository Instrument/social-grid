
var express = require('express');
var http    = require('http');
var path    = require('path');
var _       = require('underscore');
var fs      = require('fs');
var uuid    = require('node-uuid');

// load local credentials and config
var credentials = require('./credentials/env.js');

// connect to MySQL
var mysql       = require('mysql');
var connection = mysql.createConnection(credentials.mysql);

// create the application and set up the middleware
var app = express();

app.configure(function(){
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'ejs');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('foobar'));
    app.use(express.session({ secret: "fish", key: "sid" }));
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
    app.use(express.errorHandler());
});

// TODO: this should live somewhere
function filteredRows(rows) {
    return _( rows ).chain().filter( function( row ) { return swear.checker( row.text ) } ).map( function( row ) {
        return {
            id: row.id,
            type: row.type,
            approved: row.approved,
            updated_at: new Date(row.updated_at).getTime(),
            text: row.text.replace(/[\n\r\t]/g, ' '),
            social_id: row.social_id,
            image: row.image,
            name: row.name
        };
    }).value();
}

function getDateString(d) {
    return d.getUTCFullYear() + '-' + (parseInt(d.getUTCMonth()) + 1) + '-' + d.getUTCDate() + ' ' + (parseInt(d.getUTCHours()) - 9) + ':' + d.getUTCMinutes() + ':' + d.getUTCSeconds();
}

function requiresAdmin( req, res, next ) {
    if ( req.session.authenticated ) {
        console.log( req.session );
        next();
        return;
    }
    res.redirect("/login");
}

app.get('/login', function( req, res ) {
    res.render("login");
} );

app.post('/login-post', function( req, res ) {
    if ( req.body.username === credentials.username
      && req.body.password === credentials.password ) {
        req.session.authenticated = true;
        res.redirect("/live-manage");
    }
});

app.post('/logout', function( req, res ) {
    req.session.authenticated = false;
    res.redirect('/login');
});

// These require an authenticated admin
app.get('/live-manage', requiresAdmin, function( req, res ) {
    res.render("live-manage");
} );
app.get('/all', requiresAdmin, function( req, res ) {
    res.render("all");
} );
app.get('/shown', requiresAdmin, function( req, res ) {
    res.render("shown");
} );


app.get('/live-manage-longpoll', function( req, res ) {
    if (req.query['lastid']) {
        if (req.query['lastid'] != -1) {
            streams.checkForNewItems(req, res, req.query['lastid'], req.query['app']);
        } else {
            connection.query('SELECT * FROM social_grid_data order by id desc limit 1', function (err, rows, fields) {
                res.send({
                    message: "success",
                    lastid: (rows && rows[0] ? rows[0]['id'] : null)
                })
            });
        }
    } else {
        res.end('Need previous id');
    }
} );

app.get('/get-shown', function( req, res ) {
    if (req.query['lastid']) {
        if (req.query['lastid'] != -1) {
            streams.checkForNewItems(req, res, req.query['lastid'], req.query['app']);
        } else {
            connection.query('SELECT * FROM social_grid_shown JOIN social_grid_data ON social_grid_data.id=social_grid_shown.parent_id order by social_grid_shown.id desc limit 100', function (err, rows, fields) {
                connection.query('SELECT id FROM social_grid_shown order by id desc limit 1', function (err, rows, fields) {
                    res.send({
                        message: "success",
                        items: filteredRows( rows ),
                        lastid: (rows && rows[0] ? rows[0].id : null ),
                    });
                });
            });
        }
    } else {
        res.end('Need previous id');
    }
} );

app.post('/remove-items', function( req, res ) {
    connection.query('UPDATE social_grid_data SET approved=0, updated_at=NOW() where id IN(' + req.body['items'] + ')', function (err, rows, fields) {
        if (err) console.log(err);
    });

    res.send({
        message: "Successfully removed item(s) " + req.body['items']
    });
} );

app.post('/shown-items', function( req, res ) {
    console.log(req.body['items']);
    connection.query('INSERT INTO social_grid_shown (parent_id) VALUES(' + req.body['items'] + ')', function (err, rows, fields) {
        if (err) console.log(err);
    });

    res.send({
        message: "Successfully added shown item(s) " + req.body['items']
    });
} );

app.get('/get-items', function( req, res ) {
    if (req.query['lastid']) {
        if (req.query['lastid'] != -1) {
            streams.checkForNewItems(req, res, req.query['lastid'], 'application');
        } else {
            connection.query('select * from social_grid_data where updated_at < NOW() - interval 10 second and approved=1 order by id desc limit 100', function (err, rows, fields) {
                if (err) {
                    console.log("Error fetching items");
                    return;
                }
                res.send({
                    message: "success",
                    items: rows, //filteredRows( rows ),
                    lastid: ( rows && rows[0]? rows[0].id : null )
                });
            });
        }
    } else {
        res.end('Need previous id');
    }
} );



app.get('/instagram', function( req, res ) {
    console.log('Instagram Ping');
    if (req.query['hub.mode'] == 'subscribe') {
        res.end(req.query['hub.challenge'])
    } else {
        res.writeHead(200, {
            'Content-Type': 'text/plain',
            'Access-Control-Allow-Origin': '*'
        });
        res.end('Instagram Readable');
    }
} );

app.post("/instagram", function( req, res ) {
    var instagramCalls = [];
    var info = req.body;
    for (i in info) {
        var options = {
            host: 'api.instagram.com'
        };
        var url = '';
        if (info[i]['object'] == 'tag') {
            options.path = '/v1/tags/' + info[i]['object_id'] + '/media/recent?client_id=' + credentials.instagram.client_id;
        } else if (info[i]['object'] == 'geography') {
            options.path = '/v1/geographies/' + info[i]['object_id'] + '/media/recent?client_id=' + credentials.instagram.client_id;
        }
        https.request(options, function (res) {
            var body = [];
            res.setEncoding('utf8');
            res.on('data', function (chunk) {
                body.push(chunk);
            });
            res.on('end', function () {
                data = '';
                try {
                    data = JSON.parse(body.join(''));
                } catch (err) {

                }
                if (!data) { return }

                for (item in data.data) {
                    var imageText = '';
                    if (data.data[item].caption) {
                        imageText = data.data[item].caption.text;
                        imageText = imageText.replace(/"/g, '\\"').replace(/[\n\r\t]+/g, ' ');
                    }

                    var date = new Date(parseInt(data.data[item].created_time + '000'));
                    var dateString = date.toISOString().substr(0, 10) + ' ' + date.toISOString().substr(11, 8);
                    instagramCalls.push('INSERT INTO social_grid_data (type, text, image, approved, created_at, updated_at, social_id, name) VALUES("instagram", "' + imageText + '", "' + data.data[item].images.standard_resolution.url + '", 1, NOW(), NOW(), "' + data.data[item].id + '", "' + data.data[item].user.username + '")')
                }
                for (call in instagramCalls) {
                    connection.query(instagramCalls[call], function (err, rows, fields) {
                        if (err) {
                            if (err.code != 'ER_DUP_ENTRY') {
                                console.log(err);
                            }
                        }
                    });
                }
            });
        }).end();
    }
    res.writeHead(200, {
        'Content-Type': 'text/plain',
        'Access-Control-Allow-Origin': '*'
    });
    res.end('Instagram Readable');
});


// ------------------------------------------------
// handles uploads from the iPad app
// ------------------------------------------------
app.post("/photobooth-upload", function( req, res ) {
    var dir = credentials.upload_directory;

    console.log(req.files);
    if (req.files && req.files.image) {
        fs.readFile( req.files.image.path, function( err, data ) {
            var newFile = uuid.v1() + ".jpg";
            var newPath = dir + "/" + newFile;
            fs.writeFile(newPath, data, function (err) {
                if (err) {
                    console.log(err);
                    res.send(404, err);
                    return;
                }
                console.log("Uploaded to " + newPath);
                res.send( 200, "Uploaded" );
            });
            res.send(200, "Uploaded");
        });
    } else {
        res.send(404, "Hmmm!");
    }
});

http.createServer(app).listen(app.get('port'), function(){
    console.log("Express server listening on port " + app.get('port'));
});


var swear   = require('./swear');
var streams = require('./streams')(credentials, connection);

streams.checkGooglePlus();
//streams.startTwitterStream();
//streams.killInstagramStreams();