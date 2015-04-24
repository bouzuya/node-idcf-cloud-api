coffee = require 'gulp-coffee'
del = require 'del'
espower = require 'gulp-espower'
gulp = require 'gulp'
gutil = require 'gulp-util'
mocha = require 'gulp-mocha'
run = require 'run-sequence'

ignoreError = (stream) ->
  stream.on 'error', (e) ->
    gutil.log e
    @emit 'end'

gulp.task 'build', ->
  gulp.src './src/*.coffee'
  .pipe coffee(bare: true)
  .pipe gulp.dest './lib'

gulp.task 'build-test', ->
  gulp.src './test/*.coffee'
  .pipe coffee(bare: true)
  .pipe espower()
  .pipe gulp.dest './.tmp'

gulp.task 'build-test-dev', ->
  gulp.src './test/*.coffee'
  .pipe ignoreError coffee(bare: true)
  .pipe ignoreError espower()
  .pipe gulp.dest './.tmp'

gulp.task 'clean', (done) ->
  del [
    './.tmp'
    './lib'
  ], done

gulp.task 'default', (done) ->
  run.apply run, [
    'clean'
    'build'
    done
  ]

gulp.task 'test', ['build-test'], ->
  gulp.src './.tmp/**/*.js'
  .pipe mocha()

gulp.task 'test-dev', ['build-test-dev'], ->
  gulp.src './.tmp/**/*.js'
  .pipe ignoreError mocha()

gulp.task 'watch', ['test-dev'], ->
  gulp.watch [
    './src/**/*.coffee'
    './test/**/*.coffee'
  ], ['test-dev']
