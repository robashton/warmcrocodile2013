System = require './system'

Scenario "Adding a shout-out", ->
  system = new System()
  client = system.create_client()
  shoutout = null

  Given "The user is on the home page", (done) ->
    system.start ->
      client.load_index done

  When "The user writes a shout-out", ->
    client.fill('name', 'Rob')
    client.fill('shoutout', 'ERRMERRGHEEERD')

  And "submits it", (done) ->
    client.submit_shoutout done

  Then "the shout-out should appear on the page", ->
    shoutout = client.find_shoutout(0)
    shoutout.querySelector('.name').textContent.should.equal('Rob')
    shoutout.querySelector('.content').textContent.should.equal('ERRMERRGHEEERD')

  And "the shout-out text should be cleared", ->
    client.value_of('shoutout').should.equal('')

  after ->
    system.dispose()

