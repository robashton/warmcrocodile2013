var http = require('http')

var server = http.createServer(handleRequest)

function sendData(req, res, next) {
  res.write('hello world')
  next()
}

function endRequest(req, res, next) {
  res.end()
}

var handlers = []

function handleRequest(req, res) {
  var index = 0
  function handleNext() {
    var handler = handlers[index++]
    if(!handler) return
    handler(req, res, handleNext)
  }
  handleNext()
}

// We've now invented connect
handlers.push(sendData)
handlers.push(endRequest)

server.listen(8080)
