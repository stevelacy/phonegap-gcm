fission = require './app'

Index = require './pages/Index/View'
fission.router.route '/',
  view: Index
  el: 'content'
  title: 'phonegap gcm'

fission.router.start
  hashbang: true

fission.router.route '/'
