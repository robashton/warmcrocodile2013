System = require './system'

Scenario "Loading the home page", ->
  system = new System()
  client = system.create_client()

  Given "a fresh instance of shout-out", (done) ->
    system.start done

  When "visiting the home page", (done) ->
    client.load_index done

  Then "there should be a textbox for the user's name", ->
    client.can_see('input[name="name"]').should.equal(true)

  And "there should be a textbox for the user's shoutout", ->
    client.can_see('input[name="shoutout"]').should.equal(true)

  And "the application's title should be displayed", ->
    client.page_title().should.equal('Shout-out')

  after ->
    system.dispose()
