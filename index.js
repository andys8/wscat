#!/usr/bin/env node

const WebSocket = require('websocket').w3cwebsocket;
global.WebSocket = WebSocket;

const Elm = require('./dist/main');
const app = Elm.Main.worker({ args: process.argv.slice(2) });

app.ports.log.subscribe(function (message) {
    console.log(message);
});