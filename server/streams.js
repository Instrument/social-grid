var https   = require('https');
var twitter = require('ntwitter');

var twitterStream;

module.exports = function( credentials, connection ) {
    var self = {
        startTwitterStream: function(stream) {
            twitterStream = new twitter({
                consumer_key: credentials.twitter.consumer_key,
                consumer_secret: credentials.twitter.consumer_secret,
                access_token_key: credentials.twitter.access_token_key,
                access_token_secret: credentials.twitter.access_token_secret
            });
            
            console.log( twitterStream );
            twitterStream.stream(
                'statuses/filter',
                { track: credentials.tags },
                function(stream) {
                    stream.on('error', function(error, status) {
                        console.log("Twitter error: " + status + " " + error);
                    });
                    stream.on('data', function(tweet) {
                        console.log(tweet);
                        connection.query("INSERT INTO social_grid_data (type, text, approved, created_at, updated_at, social_id, name) VALUES ('twitter', '" + tweet.text.replace(/'/g, "\\'").replace(/[\n\r\t]+/g, ' ') + "', 1, NOW(), NOW(), '" + tweet.id_str + "', '" + tweet.user.screen_name + "')", function(err, rows, fields) {
                            if (err) console.log(err);
                        });
                    });
                }
            );
        },

        checkGooglePlus: function() { 
            for (i in credentials.tags) {
                var options = {
                    host: 'www.googleapis.com',
                    path: '/plus/v1/activities?query=' + credentials.tags[i].substr(1) + '&key=' + credentials.google_plus['api_key']
                };
                https.request(options, function (res) {
                    var data = [];
                    res.setEncoding('utf8');
                    res.on('data', function (chunk) {
                        data.push(chunk);
                    });
                    res.on('end', function () {
                        data = JSON.parse(data.join(''));
                        for (i in data.items) {
                            var item = data.items[i];
                            if (item.kind == 'plus#activity' && new Date() - new Date(item.published) < 60 * 60 * 24 * 7 * 1000) {
                                if (item.object.content && !item.object.attachments) {
                                    // TODO: change the type back to "googleplus" when client can accept posts from g+
                                    connection.query("INSERT INTO social_grid_data (type, text, approved, created_at, updated_at, social_id, name) VALUES ('twitter', \"" + item.object.content.replace(/<(?:.|\n)*?>/gm, '').replace(/"/g, '\\"').replace(/[\n\r\t]+/g, ' ') + "\", 1, NOW(), NOW(), '" + item.id + "', '" + item.actor.displayName + "')", function (err, rows, fields) {
                                        if (err) {
                                            if (err.code != 'ER_DUP_ENTRY') {
                                                console.log(err);
                                            }
                                        }
                                    });
                                }
                            }
                        }
                    });
                }).end();
            }
            setTimeout( self.checkGooglePlus, 15000);
        },

        killInstagramStreams: function() {
            var options = {
                host: 'api.instagram.com',
                path: '/v1/subscriptions?object=all&client_id=' + credentials.instagram.client_id + '&client_secret=' + credentials.instagram.client_secret,
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            };
            var post_req = https.request(options, function (res) {
                var data = [];
                res.setEncoding('utf8');
                res.on('data', function (chunk) {
                    data.push(chunk);
                });
                res.on('end', function () {
                    //console.log(data);
                    self.startInstagramStreams();
                });
            }).end();
        },

        startInstagramStreams: function() {
            for (i in credentials.tags) {
                var post_data = querystring.stringify({
                    'client_id': credentials.instagram.client_id,
                    'client_secret': credentials.instagram.client_secret,
                    'object': 'tag',
                    'aspect': 'media',
                    'object_id': credentials.tags[i].substr(1),
                    'callback_url': credentials.instagram.callback_url
                });
                var options = {
                    host: 'api.instagram.com',
                    path: '/v1/subscriptions/',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Content-Length': post_data.length
                    }
                };
                var post_req = https.request(options, function (res) {
                    var data = [];
                    res.setEncoding('utf8');
                    res.on('data', function (chunk) {
                        data.push(chunk);
                    });
                    res.on('end', function () {
                        //console.log(data);
                    });
                });
            
                post_req.write(post_data);
                post_req.end();
            }

        },

        checkForNewItems: function(req, res, lastid, app) {
            var date = new Date();
            if (date - req.socket._idleStart.getTime() > 29999) {
                connection.query('select * from social_grid_data where approved=0 and updated_at > NOW() - interval 2 minute', function (err, rows, fields) {
                    if (rows.length) {
                        res.send({
                            message: "success",
                            items: [],
                            remove: rows,
                            lastid: lastid
                        });
                    }
                });
            } else {
                var query = '';
                if (app == 'manage') {
                    query = 'SELECT * FROM social_grid_data where id>' + lastid;
                } else if (app == 'application') {
                    query = 'select * from social_grid_data where updated_at < NOW() - interval 10 second and approved=1 and id>' + lastid;
                } else if (app == 'shown') {
                    query = 'SELECT * FROM social_grid_shown JOIN social_grid_data ON social_grid_data.id=social_grid_shown.parent_id where social_grid_shown.id>' + lastid;
                }
                connection.query(query, function (err, rows, fields) {
                    if (err) { console.log(err); return; }
                    if (rows.length) {
                        items = rows;
                        lastid = rows[rows.length-1].id;
                        if (lastid) {
                            connection.query('select * from social_grid_data where approved=0 and updated_at > NOW() - interval 2 minute', function (err, remove, fields) {
                                if (app != 'shown') {
                                    res.send({
                                        message: "success",
                                        items: items,
                                        remove: remove,
                                        lastid: lastid
                                    })
                                    return false;
                                } else {
                                    connection.query('SELECT id FROM social_grid_shown order by id desc limit 1', function (err, rows, fields) {
                                        res.send({
                                            message: "success",
                                            items: items,
                                            remove: remove,
                                            lastid: rows[0].id
                                        });
                                    });
                                }
                            });
                        } else {
                            setTimeout(function () {
                                self.checkForNewItems(req, res, lastid, app)
                            }, 1000);
                        }
                    } else {
                        setTimeout(function () {
                            self.checkForNewItems(req, res, lastid, app)
                        }, 1000);
                    }
                });
            }
        }
    };
    return self;
};