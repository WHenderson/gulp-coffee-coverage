var coffeeCoverage, extend, gutil, path, streamBuffers, through;

coffeeCoverage = require('coffee-coverage');

extend = require('extend');

through = require('through');

path = require('path');

gutil = require('gulp-util');

streamBuffers = require('stream-buffers');

module.exports = function(options) {
  var cover, coverageInstrumentor, initFile;
  if (options == null) {
    options = {};
  }
  initFile = null;
  if (options.initfile != null) {
    if (typeof options.initfile === 'string') {
      initFile = new gutil.File({
        path: options.initfile
      });
    } else {
      initFile = new gutil.File(options.initfile);
      options.initfile = initFile.path;
    }
    options.initFileStream = new streamBuffers.WritableStreamBuffer();
  }
  coverageInstrumentor = new coffeeCoverage.CoverageInstrumentor({
    bare: options.bare,
    intrumentor: options.instumentor
  });

  /* !pragma coverage-skip-next */
  if (options.verbose) {
    coverageInstrumentor.on('instrumentingDirectory', function(sourceDir, outDir) {
      return console.log("Instrumenting directory: " + (stripLeadingDotOrSlash(sourceDir)) + " to " + (stripLeadingDotOrSlash(outDir)));
    }).on('instrumentingFile', function(sourceFile, outFile) {
      return console.log("    " + (stripLeadingDotOrSlash(sourceFile)) + " to " + (stripLeadingDotOrSlash(outFile)));
    }).on('skip', function(file) {
      return console.log("    Skipping: " + (stripLeadingDotOrSlash(file)));
    });
  }
  cover = function(file) {
    var covered;
    covered = coverageInstrumentor.instrumentCoffee(file.path, file.contents.toString(), extend({}, options, {
      fileName: file.relative
    }));
    file.contents = new Buffer(covered.init + covered.js);
    file.path = gutil.replaceExtension(file.path, '.js');
    return file;
  };
  return through(function(file) {
    var err, error;
    try {
      file = cover(file);
    } catch (error) {
      err = error;
      this.emit('error', new gutil.PluginError('coffee-coverage', err, {
        showStack: true
      }));
      return;
    }
    this.emit('data', file);
  }, function() {
    if (options.initFileStream != null) {
      options.initFileStream.end();
      initFile.contents = options.initFileStream.getContents();
      this.emit('data', initFile);
    }
    this.emit('end');
  });
};
