var gulp = require('gulp');
var gutil = require('gulp-util');
var coverage = require('../');

gulp.task('coffee-coverage', function() {
    return gulp.src('src/*.coffee')
    .pipe(coverage().on('error', gutil.log))
    .pipe(gulp.dest('dist'));
});