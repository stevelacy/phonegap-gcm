gcm = require 'node-gcm'


sender = new gcm.Sender ''
devices = []


message = new gcm.Message
  collapseKey: 'demo'
  timeToLive: 500
  data:
    title: 'phonegap gcm'
    message: 'GCM Message'
    msgcnt: 300


devices.push ''

sender.send message, devices, 4, (data) ->
  console.log data
