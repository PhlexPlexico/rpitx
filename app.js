/*Very basic file uploader with no sanity check for files.*/
var express = require('express');
var exec = require('child_process').exec;
var app = express();
var path = require('path');
var formidable = require('formidable');
var fs = require('fs');

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res){
    res.sendFile(path.join(__dirname, 'views/index.html'));
});

app.post('/toconvert', function(req, res){

    // create an incoming form object
    var form = new formidable.IncomingForm();

    /*Check if file is a .wav file, if not error.*/
    form.onPart = function (part) {
        if(!part.filename || part.filename.match(/\.(wav)$/i)) {
            this.handlePart(part);
        }
        else {
            console.log(part.filename + ' is not allowed');
        }
    }
    // specify that we want to allow the user to upload multiple files in a single request
    form.multiples = true;

    // store all uploads in the /toconvert directory
    form.uploadDir = path.join(__dirname, '/toconvert');

    // every time a file has been uploaded successfully,
    // rename it to it's orignal name
    form.on('file', function(field, file) {
        fs.rename(file.path, path.join(form.uploadDir, file.name));
    });

    // log any errors that occur
    form.on('error', function(err) {
        console.log('An error has occured: \n' + err);
    });

    // once all the files have been uploaded, send a response to the client
    form.on('end', function() {
        exec('/home/pi/rpitx/convertsongs.sh',
            function (error, stdout, stderr) {
                console.log('stdout: ' + stdout);
                console.log('stderr: ' + stderr);
                if (error !== null) {
                    console.log('exec error: ' + error);
                }
            });
        res.end('success');
    });

    // parse the incoming request containing the form data
    form.parse(req);


});

var server = app.listen(8080, function(){
    console.log('Server listening on port 8080');
});