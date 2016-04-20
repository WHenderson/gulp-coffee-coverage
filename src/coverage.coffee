coffeeCoverage = require('coffee-coverage')
extend = require('extend')
through = require('through')
path = require('path')
gutil = require('gulp-util')
streamBuffers = require('stream-buffers')

module.exports = (options = {}) ->

  initFile = null
  if options.initfile?
    if typeof options.initfile == 'string'
      initFile = new gutil.File({
        path: options.initfile
      })
    else
      initFile = new gutil.File(options.initfile)
      options.initfile = initFile.path

    options.initFileStream = new streamBuffers.WritableStreamBuffer()

  coverageInstrumentor = new coffeeCoverage.CoverageInstrumentor({
    bare: options.bare
    intrumentor: options.instumentor
  })

  ### !pragma coverage-skip-next ###
  # coffee-coverage does not yet support these events for coffee-script. Skip testing them.
  if options.verbose
    coverageInstrumentor
    .on('instrumentingDirectory', (sourceDir, outDir) ->
      console.log("Instrumenting directory: #{stripLeadingDotOrSlash sourceDir} to #{stripLeadingDotOrSlash outDir}")
    ).on('instrumentingFile', (sourceFile, outFile) ->
      console.log("    #{stripLeadingDotOrSlash sourceFile} to #{stripLeadingDotOrSlash outFile}")
    )
    .on('skip', (file) ->
      console.log("    Skipping: #{stripLeadingDotOrSlash file}")
    )

  cover = (file) ->
    covered = coverageInstrumentor.instrumentCoffee(file.path, file.contents.toString(), extend({}, options, { fileName: file.relative }))
    file.contents = new Buffer(covered.init + covered.js)
    file.path = gutil.replaceExtension(file.path, '.js')
    return file

  return through(
    (file) ->
      try
        file = cover(file)
      catch err
        @emit('error', new gutil.PluginError('coffee-coverage', err, { showStack: true }))
        return

      @emit('data', file)
      return

    () ->
      if options.initFileStream?
        options.initFileStream.end()
        initFile.contents = options.initFileStream.getContents()
        @emit('data', initFile)

      @emit('end')
      return
  )
