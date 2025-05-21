const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3005;
const htmlFilePath = path.join(__dirname, 'public', 'index.html');

const server = http.createServer((req, res) => {
    if (req.url === '/' || req.url === '/index.html') {
        fs.readFile(htmlFilePath, (err, data) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end('Internal Server Error');
                console.error(`Error reading HTML file: ${err}`);
                return;
            }
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(data);
        });
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}/`);
    console.log(`Serving HTML from: ${htmlFilePath}`);
});

// Handle server errors
server.on('error', (error) => {
    if (error.code === 'EADDRINUSE') {
        console.error(`Error: Port ${PORT} is already in use. Please use a different port or stop the existing process.`);
    } else {
        console.error(`Server error: ${error.message}`);
    }
    process.exit(1);
});
