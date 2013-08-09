console.log("This is deprecated... start app now with\n\nnode app\n\n");

// var credentials = require('./credentials/env.js');
// var http        = require('http');
// var https       = require('https');
// var url         = require('url');
// var qs          = require('querystring');
// var fs          = require('fs');
// var path        = require('path');
// var twitter     = require('ntwitter');
// var credentials = require('./credentials/env.js');
// var mysql       = require('mysql');
// var querystring = require('querystring');

// var connection = mysql.createConnection(credentials.mysql);

// var twitterStream;

// http.createServer(function (req, res) {
    // var cookies = {};
    // req.headers.cookie && req.headers.cookie.split(';').forEach(function (cookie) {
    //     var parts = cookie.split('=');
    //     cookies[parts[0].trim()] = (parts[1] || '').trim();
    // });

    // var filePath = '.' + req.url;
    // if (filePath == './') filePath = './index.htm';

    // var extname = path.extname(filePath);
    // var contentType = '';
    // switch (extname) {
    // case '.js':
    //     contentType = 'text/javascript';
    //     break;
    // case '.css':
    //     contentType = 'text/css';
    //     break;
    // }
    // if (contentType) {
    //     fs.exists(filePath, function (exists) {

    //         if (exists) {
    //             fs.readFile(filePath, function (error, content) {
    //                 if (error) {
    //                     res.writeHead(500);
    //                     res.end();
    //                 } else {
    //                     res.writeHead(200, {
    //                         'Content-Type': contentType
    //                     });
    //                     res.end(content, 'utf-8');
    //                 }
    //             });
    //         } else {
    //             res.writeHead(404);
    //             res.end();
    //         }
    //     });
    // } else {
    //     var pathname = url.parse(req.url).pathname;
    //     if (cookies.loggedin == 'n00dles' || !credentials.password || (pathname != '/' && pathname != '/live-manage' && pathname != '/all' && pathname != '/shown')) {
    //         var url_parts = url.parse(req.url, true);
    //         switch (pathname) {
    //         case '/live-manage':
    //             loadPage(req, res, 'live-manage');
    //             break;

    //         case '/shown':
    //             loadPage(req, res, 'shown');
    //             break;

    //         case '/all':
    //             loadPage(req, res, 'all');
    //             break;

    //         case '/login':
    //             if (req.method == 'POST') {
    //                 var body = '';
    //                 req.on('data', function (data) {
    //                     body += data;
    //                 });
    //                 req.on('end', function () {
    //                     var POST = qs.parse(body);
    //                     if ((POST['username'] == credentials.username && POST['password'] == credentials.password) || (!credentials.password)) {
    //                         res.writeHead(302, {
    //                             'Location': '/live-manage',
    //                             'Set-Cookie': 'loggedin=n00dles',
    //                         });
    //                         res.end();
    //                     } else {
    //                         loadPage(req, res, 'login');
    //                     }
    //                 });
    //             }
    //             break;

            // case '/get-shown':
            //     if (url_parts.query['lastid']) {
            //         if (url_parts.query['lastid'] != -1) {
            //             checkForNewItems(req, res, url_parts.query['lastid'], url_parts.query['app']);
            //         } else {
            //             connection.query('SELECT * FROM mfnw_shown JOIN mfnw_data ON mfnw_data.id=mfnw_shown.parent_id order by mfnw_shown.id desc limit 100', function (err, rows, fields) {
            //                 res.writeHead(200, {
            //                     'Content-Type': 'text/plain',
            //                     'Access-Control-Allow-Origin': '*'
            //                 });
            //                 rowBits = jsonFormatRows(rows);
            //                 connection.query('SELECT id FROM mfnw_shown order by id desc limit 1', function (err, rows, fields) {
            //                     res.write('{"message": "success", "items": ' + rowBits[0] + ', "lastid": ' + rows[0].id + '}', 'utf8');
            //                     res.end();
            //                 });
            //             });
            //         }
            //     } else {
            //         res.end('Need previous id');
            //     }
            //     break;

            // case '/live-manage-longpoll':
            //     if (url_parts.query['lastid']) {
            //         if (url_parts.query['lastid'] != -1) {
            //             checkForNewItems(req, res, url_parts.query['lastid'], url_parts.query['app']);
            //         } else {
            //             connection.query('SELECT * FROM mfnw_data order by id desc limit 1', function (err, rows, fields) {
            //                 res.writeHead(200, {
            //                     'Content-Type': 'text/plain',
            //                     'Access-Control-Allow-Origin': '*'
            //                 });
            //                 res.write('{"message": "success", "lastid": ' + rows[0]['id'] + '}', 'utf8');
            //                 res.end();
            //             });
            //         }
            //     } else {
            //         res.end('Need previous id');
            //     }
            //     break;

            // case '/remove-items':
            //     if (req.method == 'POST') {
            //         var body = '';
            //         req.on('data', function (data) {
            //             body += data;
            //         });
            //         req.on('end', function () {

            //             var POST = qs.parse(body);
            //             connection.query('UPDATE mfnw_data SET approved=0, updated_at=NOW() where id IN(' + POST['items'] + ')', function (err, rows, fields) {
            //                 if (err) console.log(err);
            //             });

            //             res.writeHead(200, {
            //                 'Content-Type': 'text/plain',
            //                 'Access-Control-Allow-Origin': '*'
            //             });
            //             res.write('{"message": "Successfully removed item(s) ' + POST['items'] + '"}', 'utf8');
            //             res.end();
            //         });
            //     } else {
            //         res.writeHead(200, {
            //             'Content-Type': 'text/plain',
            //             'Access-Control-Allow-Origin': '*'
            //         });
            //         res.write('{"message": "Should be POST"}', 'utf8');
            //         res.end();
            //     }
            //     break;

            // case '/shown-items':
            //     console.log('SHOWN ITEMS')
            //     if (req.method == 'POST') {
            //         var body = '';
            //         req.on('data', function (data) {
            //             body += data;
            //         });
            //         req.on('end', function () {
            //             var POST = qs.parse(body);
            //             console.log(POST['items']);
            //             connection.query('INSERT INTO mfnw_shown (parent_id) VALUES(' + POST['items'] + ')', function (err, rows, fields) {
            //                 if (err) console.log(err);
            //             });

            //             res.writeHead(200, {
            //                 'Content-Type': 'text/plain',
            //                 'Access-Control-Allow-Origin': '*'
            //             });
            //             res.write('{"message": "Successfully added shown item(s) ' + POST['items'] + '"}', 'utf8');
            //             res.end();
            //         });
            //     } else {
            //         res.writeHead(200, {
            //             'Content-Type': 'text/plain',
            //             'Access-Control-Allow-Origin': '*'
            //         });
            //         res.write('{"message": "Should be POST"}', 'utf8');
            //         res.end();
            //     }
            //     break;

            // case '/get-items':
            //     if (url_parts.query['lastid']) {
            //         if (url_parts.query['lastid'] != -1) {
            //             checkForNewItems(req, res, url_parts.query['lastid'], 'application');
            //         } else {
            //             connection.query('select * from mfnw_data where updated_at < NOW() - interval 10 second and approved=1 order by id desc limit 100', function (err, rows, fields) {
            //                 res.writeHead(200, {
            //                     'Content-Type': 'text/plain',
            //                     'Access-Control-Allow-Origin': '*'
            //                 });
            //                 rowBits = jsonFormatRows(rows);
            //                 res.write('{"message": "success", "items": ' + rowBits[0] + ', "lastid": ' + rowBits[1] + '}', 'utf8');
            //                 res.end();
            //             });
            //         }
            //     } else {
            //         res.end('Need previous id');
            //     }
            //     break;

//             case '/instagram':
//                 console.log('Instagram Ping');
//                 if (url_parts.query['hub.mode'] == 'subscribe') {
//                     res.end(url_parts.query['hub.challenge'])
//                 } else {
//                     if (req.method == 'POST') {
//                         var instagramCalls = [];
//                         var body = '';
//                         req.on('data', function (data) {
//                             body += data;
//                         });
//                         req.on('end', function () {
//                             var info = JSON.parse(body);
//                             for (i in info) {
//                                 var options = {
//                                     host: 'api.instagram.com'
//                                 };
//                                 var url = '';
//                                 if (info[i]['object'] == 'tag') {
//                                     options.path = '/v1/tags/' + info[i]['object_id'] + '/media/recent?client_id=' + credentials.instagram.client_id;
//                                 } else if (info[i]['object'] == 'geography') {
//                                     options.path = '/v1/geographies/' + info[i]['object_id'] + '/media/recent?client_id=' + credentials.instagram.client_id;
//                                 }
//                                 https.request(options, function (res) {
//                                     var body = [];
//                                     res.setEncoding('utf8');
//                                     res.on('data', function (chunk) {
//                                         body.push(chunk);
//                                     });
//                                     res.on('end', function () {
//                                         data = '';
//                                         try {
//                                             data = JSON.parse(body.join(''));
//                                         } catch (err) {

//                                         }
//                                         if (data) {
//                                             for (item in data.data) {
//                                                 var imageText = '';
//                                                 if (data.data[item].caption) {
//                                                     imageText = data.data[item].caption.text;
//                                                     imageText = imageText.replace(/"/g, '\\"').replace(/[\n\r\t]+/g, ' ');
//                                                 }

//                                                 var date = new Date(parseInt(data.data[item].created_time + '000'));
//                                                 var dateString = date.toISOString().substr(0, 10) + ' ' + date.toISOString().substr(11, 8);
//                                                 instagramCalls.push('INSERT INTO mfnw_data (type, text, image, approved, created_at, updated_at, social_id, name) VALUES("instagram", "' + imageText + '", "' + data.data[item].images.standard_resolution.url + '", 1, NOW(), NOW(), "' + data.data[item].id + '", "' + data.data[item].user.username + '")')
//                                             }
//                                             for (call in instagramCalls) {
//                                                 connection.query(instagramCalls[call], function (err, rows, fields) {
//                                                     if (err) {
//                                                         if (err.code != 'ER_DUP_ENTRY') {
//                                                             console.log(err);
//                                                         }
//                                                     }
//                                                 });
//                                             }
//                                         }
//                                     });
//                                 }).end();
//                             }
//                         });
//                     }
//                     res.writeHead(200, {
//                         'Content-Type': 'text/plain',
//                         'Access-Control-Allow-Origin': '*'
//                     });
//                     res.end('Instagram Readable');
//                 }
//                 break;

//             case '/':
//                 res.writeHead(200, {
//                     'Content-Type': 'text/plain',
//                     'Access-Control-Allow-Origin': '*'
//                 });
//                 loadPage(req, res, 'index')
//                 break;

//             default:
//                 res.end('404');
//             }
//         } else {
//             loadPage(req, res, 'login');
//         }
//     }
// }).listen(1337);
// console.log('Server running');

// checkGooglePlus();
// startTwitterStream();
// killInstagramStreams();

// function startTwitterStream(stream) {
//     twitterStream = new twitter({
// 	    consumer_key: credentials.twitter.consumer_key,
// 	    consumer_secret: credentials.twitter.consumer_secret,
// 	    access_token_key: credentials.twitter.access_token_key,
// 	    access_token_secret: credentials.twitter.access_token_secret
// 	});
    
//     twitterStream.stream(
//     	'statuses/filter',
//     	{ track: credentials.tags },
//     	function(stream) {
//        		 stream.on('data', function(tweet) {
// 	       		 connection.query("INSERT INTO mfnw_data (type, text, approved, created_at, updated_at, social_id, name) VALUES ('twitter', '" + tweet.text.replace(/'/g, "\\'").replace(/[\n\r\t]+/g, ' ') + "', 1, NOW(), NOW(), '" + tweet.id_str + "', '" + tweet.user.screen_name + "')", function(err, rows, fields) {
// 		       		 if (err) console.log(err);
// 		          });
// 		      });
//         }
//     );
// }

// function loadPage(req, res, page) {
//     fs.readFile('./public/base.html', 'ascii', function read(err, data) {
//         if (err) console.log(err);
//         var header = data.substr(0, data.indexOf('id="main"') + 11);
//         var footer = data.substr(data.indexOf('id="main"') + 11);
//         fs.readFile('./public/' + page + '.html', 'ascii', function read(err, data) {
//             res.writeHead(200, {
//                 'Content-Type': 'text/html',
//                 'Access-Control-Allow-Origin': '*'
//             });
//             res.end(header + data + footer);
//         });
//     });
// }

// function checkGooglePlus() { 
//     for (i in credentials.tags) {
//         var options = {
//             host: 'www.googleapis.com',
//             path: '/plus/v1/activities?query=' + credentials.tags[i].substr(1) + '&key=AIzaSyDqrta7YH8_5IFU20mxavM393T3P4dZiMo'
//         };
//         https.request(options, function (res) {
//             var data = [];
//             res.setEncoding('utf8');
//             res.on('data', function (chunk) {
//                 data.push(chunk);
//             });
//             res.on('end', function () {
//                 data = JSON.parse(data.join(''));
//                 for (i in data.items) {
//                     var item = data.items[i];
//                     if (item.kind == 'plus#activity' && new Date() - new Date(item.published) < 60 * 60 * 24 * 7 * 1000) {
//                         if (item.object.content && !item.object.attachments) {
//                             connection.query("INSERT INTO mfnw_data (type, text, approved, created_at, updated_at, social_id, name) VALUES ('googleplus', \"" + item.object.content.replace(/<(?:.|\n)*?>/gm, '').replace(/"/g, '\\"').replace(/[\n\r\t]+/g, ' ') + "\", 1, NOW(), NOW(), '" + item.id + "', '" + item.actor.displayName + "')", function (err, rows, fields) {
//                                 if (err) {
//                                     if (err.code != 'ER_DUP_ENTRY') {
//                                         console.log(err);
//                                     }
//                                 }
//                             });
//                         }
//                     }
//                 }
//             });
//         }).end();
//     }
//     setTimeout(checkGooglePlus, 15000);
// }

// function killInstagramStreams() {
// 	var options = {
//         host: 'api.instagram.com',
//         path: '/v1/subscriptions?object=all&client_id=' + credentials.instagram.client_id + '&client_secret=' + credentials.instagram.client_secret,
//         method: 'DELETE',
//         headers: {
//             'Content-Type': 'application/x-www-form-urlencoded'
//         }
//     };
//     var post_req = https.request(options, function (res) {
//         var data = [];
//         res.setEncoding('utf8');
//         res.on('data', function (chunk) {
//             data.push(chunk);
//         });
//         res.on('end', function () {
//             //console.log(data);
//             startInstagramStreams();
//         });
//     }).end();
// }

// function startInstagramStreams() {
// 	for (i in credentials.tags) {
// 	    var post_data = querystring.stringify({
// 	        'client_id': credentials.instagram.client_id,
// 	        'client_secret': credentials.instagram.client_secret,
// 	        'object': 'tag',
// 	        'aspect': 'media',
// 	        'object_id': credentials.tags[i].substr(1),
// 	        'callback_url': credentials.instagram.callback_url
// 	    });
// 	    var options = {
// 	        host: 'api.instagram.com',
// 	        path: '/v1/subscriptions/',
// 	        method: 'POST',
// 	        headers: {
// 	            'Content-Type': 'application/x-www-form-urlencoded',
// 	            'Content-Length': post_data.length
// 	        }
// 	    };
// 	    var post_req = https.request(options, function (res) {
// 	        var data = [];
// 	        res.setEncoding('utf8');
// 	        res.on('data', function (chunk) {
// 	            data.push(chunk);
// 	        });
// 	        res.on('end', function () {
// 	            //console.log(data);
// 	        });
// 	    });
	
// 	    post_req.write(post_data);
// 	    post_req.end();
// 	}

// }

// function checkForNewItems(req, res, lastid, app) {
//     var date = new Date();
//     if (date - req.socket._idleStart.getTime() > 29999) {
//         res.writeHead(200, {
//             'Content-Type': 'text/plain',
//             'Access-Control-Allow-Origin': '*'
//         });
//         connection.query('select * from mfnw_data where approved=0 and updated_at > NOW() - interval 2 minute', function (err, rows, fields) {
//             removeBits = ['[{}]'];
//             if (rows.length) {
//                 removeBits = jsonFormatRows(rows);
//                 res.write('{"message": "success", "items": [{}], "remove": ' + removeBits[0] + ', "lastid": ' + lastid + '}', 'utf8');
//                 res.end();
//             }
//         });
//     } else {
//         var query = '';
//         if (app == 'manage') {
//             query = 'SELECT * FROM mfnw_data where id>' + lastid;
//         } else if (app == 'application') {
//             query = 'select * from mfnw_data where updated_at < NOW() - interval 10 second and approved=1 and id>' + lastid;
//         } else if (app == 'shown') {
//             query = 'SELECT * FROM mfnw_shown JOIN mfnw_data ON mfnw_data.id=mfnw_shown.parent_id where mfnw_shown.id>' + lastid;
//         }
//         connection.query(query, function (err, rows, fields) {
//             if (err) console.log(err);
//             if (rows.length) {
//                 res.writeHead(200, {
//                     'Content-Type': 'text/plain',
//                     'Access-Control-Allow-Origin': '*'
//                 });
//                 rowBits = jsonFormatRows(rows);
//                 if (rowBits[1]) {
//                     connection.query('select * from mfnw_data where approved=0 and updated_at > NOW() - interval 2 minute', function (err, rows, fields) {
//                         removeBits = ['[{}]'];
//                         if (rows.length) {
//                             removeBits = jsonFormatRows(rows);
//                         }
//                         if (app != 'shown') {
//                             res.write('{"message": "success", "items": ' + rowBits[0] + ', "remove": ' + removeBits[0] + ', "lastid": ' + rowBits[1] + '}', 'utf8');
//                             res.end();

//                             return false;
//                         } else {
//                             connection.query('SELECT id FROM mfnw_shown order by id desc limit 1', function (err, rows, fields) {
//                                 res.write('{"message": "success", "items": ' + rowBits[0] + ', "remove": ' + removeBits[0] + ', "lastid": ' + rows[0].id + '}', 'utf8');
//                                 res.end();
//                             });
//                         }
//                     });
//                 } else {
//                     setTimeout(function () {
//                         checkForNewItems(req, res, lastid, app)
//                     }, 1000);
//                 }
//             } else {
//                 setTimeout(function () {
//                     checkForNewItems(req, res, lastid, app)
//                 }, 1000);
//             }
//         });
//     }
// };

// function jsonFormatRows(rows) {
//     var returnRows = '[';
//     var lastid;
//     for (row in rows) {
//         if (!swearChecker(rows[row].text)) {
//             returnRows += '{';
//             returnRows += '"id":"' + rows[row].id + '",';
//             returnRows += '"type":"' + rows[row].type + '",';
//             returnRows += '"approved":"' + rows[row].approved + '",';
//             returnRows += '"updated_at":' + new Date((rows[row].updated_at)).getTime() + ',';
//             if (rows[row].text) {
//                 returnRows += '"text":"' + rows[row].text.replace(/"/g, '\\"').replace(/[\n\r\t]+/g, ' ') + '",';
//             }
//             returnRows += '"social_id":"' + rows[row].social_id + '",';
//             if (rows[row].image) {
//                 returnRows += '"image":"' + rows[row].image + '",';
//             }
//             returnRows += '"name":"' + rows[row].name + '"';
//             returnRows += '},';
//             lastid = rows[row].id;
//         }
//     }
//     return [returnRows.substr(0, returnRows.length - 1) + ']', lastid];
// }

// function getDateString(d) {
//     return d.getUTCFullYear() + '-' + (parseInt(d.getUTCMonth()) + 1) + '-' + d.getUTCDate() + ' ' + (parseInt(d.getUTCHours()) - 9) + ':' + d.getUTCMinutes() + ':' + d.getUTCSeconds();
// }

// function swearChecker(txt) {
//     if (!txt) {
//         return false;
//     }
//     for (key in swears) {
//         var pattern = new RegExp(key, 'g');
//         if (txt.match(pattern)) {
//             return true;
//         }
//     }
//     return false;
// }

// var swears = {"4r5e":1,"5h1t":1,"5hit":1,a55:1,anal:1,anus:1,ar5e:1,arrse:1,arse:1,ass:1,"ass-fucker":1,asses:1,assfucker:1,assfukka:1,asshole:1,assholes:1,asswhole:1,a_s_s:1,"b!tch":1,b00bs:1,b17ch:1,b1tch:1,ballbag:1,balls:1,ballsack:1,bastard:1,beastial:1,beastiality:1,bellend:1,bestial:1,bestiality:1,"bi+ch":1,biatch:1,bitch:1,bitcher:1,bitchers:1,bitches:1,bitchin:1,bitching:1,bloody:1,"blow job":1,blowjob:1,blowjobs:1,boiolas:1,bollock:1,bollok:1,boner:1,boob:1,boobs:1,booobs:1,boooobs:1,booooobs:1,booooooobs:1,breasts:1,buceta:1,bugger:1,bum:1,"bunny fucker":1,butt:1,butthole:1,buttmuch:1,buttplug:1,c0ck:1,c0cksucker:1,"carpet muncher":1,cawk:1,chink:1,cipa:1,cl1t:1,clit:1,clitoris:1,clits:1,cnut:1,cock:1,"cock-sucker":1,cockface:1,cockhead:1,cockmunch:1,cockmuncher:1,cocks:1,"cocksuck ":1,"cocksucked ":1,cocksucker:1,cocksucking:1,"cocksucks ":1,cocksuka:1,cocksukka:1,cok:1,cokmuncher:1,coksucka:1,coon:1,cox:1,crap:1,cum:1,cummer:1,cumming:1,cums:1,cumshot:1,cunilingus:1,cunillingus:1,cunnilingus:1,cunt:1,"cuntlick ":1,"cuntlicker ":1,"cuntlicking ":1,cunts:1,cyalis:1,cyberfuc:1,"cyberfuck ":1,"cyberfucked ":1,cyberfucker:1,cyberfuckers:1,"cyberfucking ":1,d1ck:1,damn:1,dick:1,dickhead:1,dildo:1,dildos:1,dink:1,dinks:1,dirsa:1,dlck:1,"dog-fucker":1,doggin:1,dogging:1,donkeyribber:1,doosh:1,duche:1,dyke:1,ejaculate:1,ejaculated:1,"ejaculates ":1,"ejaculating ":1,ejaculatings:1,ejaculation:1,ejakulate:1,"f u c k":1,"f u c k e r":1,f4nny:1,fag:1,fagging:1,faggitt:1,faggot:1,faggs:1,fagot:1,fagots:1,fags:1,fanny:1,fannyflaps:1,fannyfucker:1,fanyy:1,fatass:1,fcuk:1,fcuker:1,fcuking:1,feck:1,fecker:1,felching:1,fellate:1,fellatio:1,"fingerfuck ":1,"fingerfucked ":1,"fingerfucker ":1,fingerfuckers:1,"fingerfucking ":1,"fingerfucks ":1,fistfuck:1,"fistfucked ":1,"fistfucker ":1,"fistfuckers ":1,"fistfucking ":1,"fistfuckings ":1,"fistfucks ":1,flange:1,fook:1,fooker:1,fuck:1,fucka:1,fucked:1,fucker:1,fuckers:1,fuckhead:1,fuckheads:1,fuckin:1,fucking:1,fuckings:1,fuckingshitmotherfucker:1,"fuckme ":1,fucks:1,fuckwhit:1,fuckwit:1,"fudge packer":1,fudgepacker:1,fuk:1,fuker:1,fukker:1,fukkin:1,fuks:1,fukwhit:1,fukwit:1,fux:1,fux0r:1,f_u_c_k:1,gangbang:1,"gangbanged ":1,"gangbangs ":1,gaylord:1,gaysex:1,goatse:1,God:1,"god-dam":1,"god-damned":1,goddamn:1,goddamned:1,"hardcoresex ":1,hell:1,heshe:1,hoar:1,hoare:1,hoer:1,homo:1,hore:1,horniest:1,horny:1,hotsex:1,"jack-off ":1,jackoff:1,jap:1,"jerk-off ":1,jism:1,"jiz ":1,"jizm ":1,jizz:1,kawk:1,knob:1,knobead:1,knobed:1,knobend:1,knobhead:1,knobjocky:1,knobjokey:1,kock:1,kondum:1,kondums:1,kum:1,kummer:1,kumming:1,kums:1,kunilingus:1,"l3i+ch":1,l3itch:1,labia:1,lmfao:1,lust:1,lusting:1,m0f0:1,m0fo:1,m45terbate:1,ma5terb8:1,ma5terbate:1,masochist:1,"master-bate":1,masterb8:1,"masterbat*":1,masterbat3:1,masterbate:1,masterbation:1,masterbations:1,masturbate:1,"mo-fo":1,mof0:1,mofo:1,mothafuck:1,mothafucka:1,mothafuckas:1,mothafuckaz:1,"mothafucked ":1,mothafucker:1,mothafuckers:1,mothafuckin:1,"mothafucking ":1,mothafuckings:1,mothafucks:1,"mother fucker":1,motherfuck:1,motherfucked:1,motherfucker:1,motherfuckers:1,motherfuckin:1,motherfucking:1,motherfuckings:1,motherfuckka:1,motherfucks:1,muff:1,mutha:1,muthafecker:1,muthafuckker:1,muther:1,mutherfucker:1,n1gga:1,n1gger:1,nazi:1,nigg3r:1,nigg4h:1,nigga:1,niggah:1,niggas:1,niggaz:1,nigger:1,"niggers ":1,nob:1,"nob jokey":1,nobhead:1,nobjocky:1,nobjokey:1,numbnuts:1,nutsack:1,"orgasim ":1,"orgasims ":1,orgasm:1,"orgasms ":1,p0rn:1,pawn:1,pecker:1,penis:1,penisfucker:1,phonesex:1,phuck:1,phuk:1,phuked:1,phuking:1,phukked:1,phukking:1,phuks:1,phuq:1,pigfucker:1,pimpis:1,piss:1,pissed:1,pisser:1,pissers:1,"pisses ":1,pissflaps:1,"pissin ":1,pissing:1,"pissoff ":1,poop:1,porn:1,porno:1,pornography:1,pornos:1,prick:1,"pricks ":1,pron:1,pube:1,pusse:1,pussi:1,pussies:1,pussy:1,"pussys ":1,rectum:1,retard:1,rimjaw:1,rimming:1,"s hit":1,"s.o.b.":1,sadist:1,schlong:1,screwing:1,scroat:1,scrote:1,scrotum:1,semen:1,sex:1,"sh!+":1,"sh!t":1,sh1t:1,shag:1,shagger:1,shaggin:1,shagging:1,shemale:1,"shi+":1,shit:1,shitdick:1,shite:1,shited:1,shitey:1,shitfuck:1,shitfull:1,shithead:1,shiting:1,shitings:1,shits:1,shitted:1,shitter:1,"shitters ":1,shitting:1,shittings:1,"shitty ":1,skank:1,slut:1,sluts:1,smegma:1,smut:1,snatch:1,"son-of-a-bitch":1,spac:1,spunk:1,s_h_i_t:1,t1tt1e5:1,t1tties:1,teets:1,teez:1,testical:1,testicle:1,tit:1,titfuck:1,tits:1,titt:1,tittie5:1,tittiefucker:1,titties:1,tittyfuck:1,tittywank:1,titwank:1,tosser:1,turd:1,tw4t:1,twat:1,twathead:1,twatty:1,twunt:1,twunter:1,v14gra:1,v1gra:1,vagina:1,viagra:1,vulva:1,w00se:1,wang:1,wank:1,wanker:1,wanky:1,whoar:1,whore:1,willies:1,willy:1,xrated:1,xxx:1}