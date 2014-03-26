var http = require('http');

var app = function(request, response) {
   response.writeHead(200, { 'Content-Type': 'text/html' });
   response.write('<html>');
   response.write('<body>');
   response.write('<h1>Hello, world!</h1>');
   response.write('</body>');
   response.write('</html>');
   response.end();
}

var port = 8080;

console.log('server started - listening on port: ' + port);
http.createServer(app).listen(port)
