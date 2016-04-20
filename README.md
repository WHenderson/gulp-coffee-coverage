# gulp-coffee-coverage
gulp plugin for coffee-coverage. Compiles CoffeeScript into Javascript with coverage logic.

## Usage

```javascript
var coverage = require('../');

gulp.task('coffee-coverage', function() {
    return gulp.src('src/*.coffee')
    .pipe(coverage().on('error', gutil.log))
    .pipe(gulp.dest('dist'));
});
```

### Error handling

gulp-coffee-coverage will emit an error for cases such as invalid coffeescript syntax. If uncaught, the error will crash gulp.

You will need to attach a listener (i.e. `.on('error')`) for the error event emitted by gulp-coffee-coverage:

```javascript
var coverageStream = coverage({bare: true});

// Attach listener
coverageStream.on('error', function(err) {});
```

In addition, you may utilize [gulp-util](https://github.com/wearefractal/gulp-util)'s logging function:

```javascript
var gutil = require('gulp-util');

// ...

var coverageStream = coverage({bare: true});

// Attach listener
coverageStream.on('error', gutil.log);

```

Since `.on(...)` returns `this`, you can compact it as inline code:

```javascript

gulp.src('./src/*.coffee')
  .pipe(coverage({bare: true}).on('error', gutil.log))
  // ...
```

### Options

|name|type|description|
|----|----|-----------|
|bare|Boolean|Do not wrap files in an anonymous function|
|initfile|String|Generate an coverage initiation file|
|initfile|Object Literal|Generate an coverage initiation file. Options are used to initialise the vinyl-fs file added to the stream |
|instrumentor|String|Instrumentor to use with coffee-coverage. Either 'istanbul' or 'jscoverage'|

## Installation

```
npm install --save-dev gulp-coffee-coverage
```
 