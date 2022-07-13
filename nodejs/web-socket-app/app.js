const express = require('express');
const app = express();
var expressWs = require('express-ws')(app);

app.ws('/time', function(ws, req) {
	const date = new Date().toLocaleString('en-US', { timeZone: 'Asia/Yangon' });
	ws.send(date);
	setInterval(() => {
		const now = new Date().toLocaleString('en-US', { timeZone: 'Asia/Yangon' });
		ws.send(now);
	}, 1000);
});

app.ws('/chat', function(ws, req) {
	ws.send("Hello");
  ws.on('message', function(msg) {
    ws.send(msg);
  });
});

app.listen(3000, () => {
	console.log("Server started at port: 3000");
});