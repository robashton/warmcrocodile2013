var express = require('express')
var stylus = require('stylus')
var jade = require('jade')

var server = express()

server.use(express.static(__dirname + '/site'))
server.use(express.bodyParser())

server.set('view engine', 'jade')
server.set('views', 'views')
server.engine('jade', jade.__express)

server.use(stylus.middleware({
  src: __dirname + '/views',
  dest: 'site',
  debug: false}))

server.get('/hello', function(req, res) {
  res.write('hello world')
  res.end()
})

var items = []

server.get('/', function(req, res) {
  res.render('index', {
    items: items
  })
})

server.post('/', function(req, res) {
  items.unshift(req.body)
  res.render('shoutout', {
    item: req.body
  })
})

var listeners = [] 

server.listen(process.env.PORT || 8080)
