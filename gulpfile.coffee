{spawn} = require 'child_process'

gulp = require 'gulp'

source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
coffeeify  = require 'coffeeify'
browserify   = require 'browserify'

jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
plumber = require 'gulp-plumber'
reload = require 'gulp-livereload'
replace = require 'gulp-replace'
concat = require 'gulp-concat'

gutil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'

autowatch = require 'gulp-autowatch'


# paths
paths =
  vendor: './client/vendor/**/*'
  img: './client/img/**/*'
  fonts: './client/fonts/**/*'
  coffee: './client/**/*.coffee'
  coffeeSrc: './client/start.coffee'
  stylus: './client/**/*.styl'
  jade: './client/**/*.jade'
  public: './public'

gulp.task 'server', (cb) ->
  # total hack to make nodemon + livereload
  # work sanely
  idxPath = './public/index.html'
  reloader = reload()
  nodemon
    script: './server/index.coffee'
    watch: ['./server']
    ext: 'js json coffee'
    ignore: './server/test'
  .once 'start', cb
  .on 'start', ->
    console.log 'Server has started'
    setTimeout ->
      #reloader.write path: idxPath
      console.log ''
    , 1000
  .on 'quit', ->
    console.log 'Server has quit'
  .on 'restart', (files) ->
    console.log 'Server restarted due to:', files

  #return

# javascript
gulp.task 'coffee', ->
  bCache = {}
  b = browserify paths.coffeeSrc,
    debug: true
    insertGlobals: true
    cache: bCache
    extensions: ['.coffee']
  b.transform coffeeify
  b.bundle()
  .pipe source 'start.js'
  .pipe buffer()
  .pipe plumber()
  .pipe gulp.dest paths.public
  .pipe reload()

# styles
gulp.task 'stylus', ->
  gulp.src paths.stylus
    .pipe sourcemaps.init()
    .pipe stylus()
    .pipe concat 'app.css'
    .pipe sourcemaps.write()
    .pipe gulp.dest paths.public
    .pipe reload()

gulp.task 'jade', ->
  gulp.src paths.jade
    .pipe jade()
    .pipe gulp.dest paths.public
    .pipe reload()

gulp.task 'vendor', ->
  gulp.src paths.vendor
    .pipe cache 'vendor'
    .pipe gulp.dest './public/vendor'
    .pipe reload()

gulp.task 'img', ->
  gulp.src paths.img
    .pipe cache 'img'
    .pipe gulp.dest './public/img'
    .pipe reload()

gulp.task 'watch', ->
  autowatch gulp, paths


gulp.task 'phonegap', ->
  gulp.src './public/**/*'
  .pipe gulp.dest './www'
  .on 'end', ->
    cmd = spawn 'phonegap', ['run', 'android'], cwd: __dirname
    cmd.stdout.on 'data', (data) ->
      console.log String data
    cmd.stderr.on 'data', (data) ->
      console.log String data
      process.exit 1

gulp.task 'css', ['stylus']
gulp.task 'js', ['coffee']
gulp.task 'static', ['jade', 'vendor', 'img']
gulp.task 'default', ['js', 'css', 'static', 'server', 'watch']
