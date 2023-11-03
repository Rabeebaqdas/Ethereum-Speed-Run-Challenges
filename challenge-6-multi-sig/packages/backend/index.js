var express = require("express");
var fs = require("fs");
const https = require('https')
var cors = require('cors')
var bodyParser = require("body-parser");
var app = express();
const PORT = 49832;
let transactions = {}

app.use(cors())

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", function (req, res) {
  console.log("/")
  res.status(200).send("hello world");
});
app.get("/:key", function (req, res) {
  let key = req.params.key
  console.log("/", key)
  res.status(200).send(transactions[key]);
});


app.post('/', function (request, response) {
  console.log("POOOOST!!!!", request.body);      // your JSON
  response.send(request.body);    // echo the result back
  const key = request.body.address + "_" + request.body.chainId
  console.log("key:", key)
  if (!transactions[key]) {
    transactions[key] = {}
  }
  transactions[key][request.body.hash] = request.body
  console.log("transactions", transactions)
});


app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});

// Export the Express API
module.exports = app
