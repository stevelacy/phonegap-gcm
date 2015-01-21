fission = require '../../app'
PushNotification = require '../../vendor/PushNotification'

DOM = fission.DOM

window.onNotificationGCM = (e) ->
  if e.event == 'registered'
    alert "registered: #{e.regid}"
    return console.log "registered: #{e.regid}"
  if e.event == 'message'
    console.log 'message', e.message
    return alert "message, #{e.message}"


registerGCM = (cb) ->
  opts =
    senderID: '' ######## << add sender id here
    ecb: 'window.onNotificationGCM'
  pushNotification = new PushNotification()
  pushNotification.register (result) ->
    console.log result
    cb()
  , (err) ->
    console.log JSON.stringify err
    cb()
  , opts

module.exports = fission.view
  register: ->
    registerGCM =>
      @setState registered: true
  init: ->
    o =
      registered: false
      id: null
    return o
  render: ->
    DOM.div null,
      DOM.h1 null, 'GCM test'
      if !@state.registered
        DOM.button
          onClick: @register
        , 'click to register with GCM'
      else
        DOM.h3 null, 'registered'
