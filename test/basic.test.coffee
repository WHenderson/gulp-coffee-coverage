gulp = require('gulp')
path = require('path')
del = require('del')
compare = require('./compare')
assert = require('chai').assert

suite('basic', () ->
  gCoverage = null
  @timeout(5000)

  suiteSetup((cb) ->
    gCoverage = require('../src/coverage')

    del(path.join(__dirname, 'found'))
    .then(() ->
      cb()
    )

    return
  )

  validate = (name, input, options, expectedError) ->
    test(name, (cb) ->
      gulp
      .src(path.join(__dirname, 'fixtures', input))
      .pipe(gCoverage(options))
      .on('error', (err) ->
        if expectedError?
          try
            assert.throws(
              () -> throw err
              expectedError
            )
          catch err2
            return cb(err2)

          return cb()
        else
          return cb(err)
      )
      .pipe(gulp.dest(path.join(__dirname, 'found', name)))
      .on('end', () ->
        compare('**/*.*', path.join(__dirname, 'found', name), path.join(__dirname, 'expected', name))
        .then(cb,cb)
      )

      return
    )

  validate(
    'default',
    'input.coffee'
  )
  validate(
    'initfile',
    'input.coffee',
    {
      initfile: 'coverage-init.js'
    }
  )
  validate(
    'initfile-detailed',
    'input.coffee',
    {
      initfile: {
        path: '/a/init/coverage.js'
        base: '/a'
        cwd: '/'
    }
  })
  validate(
    'error',
    'error.coffee',
    {},
    'Could not parse'
  )
)