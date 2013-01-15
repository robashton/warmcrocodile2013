debug = !!process.env.DEBUG
Browser = require 'zombie'
fork = require('child_process').fork
http = require 'http'

class ManualContext
  constructor: ->
    @server = null
    @port = parseInt(Math.random() * 63000) + 1000
    @closed_listener = null

  start: (done) =>
    @server= fork(process.cwd() + '/server.js',[], {
      silent: !debug,
      env: {
        PORT: @port
        TEST: true
      }
    })
    @wait_for_server(done)

  wait_for_server: (done) =>
    req = http.get "http://localhost:" + @port, =>
      done()
    req.on 'error', =>
      @wait_for_server(done)

  create_client: =>
    return new ManualClient(this, @port)

  dispose: =>
    @server.kill()


class ManualClient
  constructor: (context, port) ->
    @browser = null
    @page = null
    @port = port
    @base = 'http://localhost:' + port
    @context = context

  navigate: (url, done) =>
    @page = @base + url
    @browser = new Browser({debug: debug})
    @browser.on 'error', (err) ->
      console.log(err.toString())
    @browser.visit @page, done

  can_see: (selector) =>
    element = @browser.querySelector(selector)
    return !!element

  fill: (name, value) =>
    @browser.fill(name, value)

  submit_shoutout: (done) =>
    submit = @browser.querySelector('#submit')
    @browser.fire('click', submit, done)

  page_title: =>
    return @browser.querySelector('h1').textContent

  value_of: (inputSelector) =>
    item = @browser.querySelector("input[name='#{inputSelector}']")
    return item.getAttribute('value') || ''

  find_shoutout: (index) =>
    shoutouts = @browser.querySelectorAll('.shoutout')
    return shoutouts[index]

  load_index: (cb) =>
    @navigate '/', cb
    
module.exports = ManualContext
