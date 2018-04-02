var videosDirectory = 'processing_mapper/data/';

var path = require('path');
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



    if (error) {
        console.log(error);
    }
    if (!error && response.statusCode == 200) {
        var info = JSON.parse(body);
        var newFile = false;

        var newFileName;

        for (var i = 0; i < info.length; i++) {
            var fileName = info[i];
            if (fileName != 'temp-download') {
                if (!fs.existsSync(videosDirectory + fileName)) {

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
                    console.log('Beginning download of ' + newFileName + ', code: ' + response.statusCode);

                })
                .pipe(fs.createWriteStream(videosDirectory + newFileName + '.tmp').on('finish', function () {
                    console.log('Finished downloading ' + newFileName);
                    fs.rename(videosDirectory + newFileName + '.tmp', videosDirectory + newFileName, function () {
                        downloading = false;
                    });

                }));
        } else {
            console.log(clc.blackBright('No new files found.'));
        }

        // Check for unused files...
        var localFiles = fs.readdir(videosDirectory, function (err, files) {
            if (err) {
                console.log(err);
            }
            
            for (var i = 0; i < files.length; i++) {
                var existsOnServer = false;
                for (var j = 0; j < info.length; j++) {
                    if(files[i] == info[j]){
                        existsOnServer = true;
                    }
                }
                if(!existsOnServer && path.extname(files[i]) != '.tmp'){
                    console.log(files[i] + ' does not exist on the server. Deleting...');
                    fs.unlink(videosDirectory + files[i], function(){
                        console.log('Finished deleting unused file.');
                    });
                }
            }
        });
    }
}

function checkServer() {
    if (!downloading) {
        console.log('Checking server...');
        request(options, callback);
    }

}

if (!fs.existsSync(videosDirectory)) {
    fs.mkdirSync(videosDirectory);
}

checkServer();
setInterval(checkServer, 5000);