var clc = require('cli-color');
console.log(clc.red.bgBlack.bold('Hello Dave. You\'re Looking well today.'));

require('dotenv').config();

var venueDirectory = process.env.VENUE_DIRECTORY;
var targetURL = 'http://theodoremichels.tech:3333/venues/' + venueDirectory + '/videos/';
console.log('Checking target directory: ' + targetURL);

var request = require('request');

var fs = require('fs');

var downloading = false;

var options = {
    url: targetURL
};

function callback(error, response, body) {
    if(error){
        console.log(error);
    }
    if (!error && response.statusCode == 200) {
        var info = JSON.parse(body);
        var newFile = false;

        var newFileName;
        
        for (var i = 0; i < info.length; i++) {
            var fileName = info[i];
            if (fileName != 'temp-download') {
                if (!fs.existsSync('data/' + fileName)) {

                    newFile = true;
                    newFileName = fileName;
                    console.log('New File: ' + clc.green(newFileName));
                }
            }
        }

        if (newFile) {
            downloading = true;
            request
                .get('http://theodoremichels.tech/venues/videos/' + venueDirectory + '/' + newFileName)
                .on('error', function (err) {
                    console.log(err);
                })
                .on('response', function (response) {
                    console.log('Beginning download of '+ newFileName +', code: ' + response.statusCode);

                })
                .pipe(fs.createWriteStream('data/' + newFileName + '.tmp').on('finish', function () {
                    console.log('Finished downloading ' + newFileName);
                    fs.rename('data/' + newFileName + '.tmp', 'data/' + newFileName, function(){
                        downloading = false;
                    });
                    
                }));
        }else{
            console.log(clc.blackBright('No new files found.'));
        }

    }
}

function checkServer() {
    if(!downloading){
        console.log('Checking server...');
        request(options, callback);
    }
    
}

if (!fs.existsSync('data')) {
    fs.mkdirSync('data');
}

checkServer();
setInterval(checkServer, 5000);