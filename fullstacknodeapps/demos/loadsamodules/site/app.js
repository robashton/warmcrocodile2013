$(function() {
  var $name = $("input[name='name']") 
  var $shoutout = $("input[name='shoutout']")
  $("#submit").click(function() {
      var name = $name.val()
      var shoutout = $shoutout.val()

      $.ajax({
        url: '/',
        type: 'POST',
        data: { name: name, shoutout: shoutout },
        success: function(html) {
          $('#shoutouts').prepend(html)
        }
      })
      $shoutout.val('')
  })
})
