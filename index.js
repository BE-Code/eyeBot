const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3005;

// Create a simple HTML file if it doesn't exist
const htmlFilePath = path.join(__dirname, 'public', 'index.html');
const publicDir = path.join(__dirname, 'public');

if (!fs.existsSync(publicDir)) {
    fs.mkdirSync(publicDir);
}

if (!fs.existsSync(htmlFilePath)) {
    const defaultHtmlContent = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiosk Display</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #282c34;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            font-size: 5vw;
            text-align: center;
        }
        .container {
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Kiosk Mode!</h1>
        <p>This is a locally served page.</p>
    </div>
</body>
</html>
`;
    fs.writeFileSync(htmlFilePath, defaultHtmlContent);
    console.log(`Created default HTML at ${htmlFilePath}`);
}

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