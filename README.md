# grunt-sass-format

> Check format of sass you wish.

## Getting Started
This plugin requires Grunt `~0.4.3`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-sass-format --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-sass-format');
```

## The "sassFormat" task

### Overview
In your project's Gruntfile, add a section named `sass_format` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  sassFormat: {
    options: {
      indentChar:'\t'
      indentStep:1
      blankLine:
        property:true
        close:true
      whiteSpace:
        selector:true
        property:true
      order:true
      lang:'en'
      debug:false
    },
    files:['path/to/target/files']
  },
});
```

### Options

#### options.indentChar
Type: `String`
Default value: `'\t'`

#### options.indentStep
Type: `Number`
Default value: `1`

#### options.blankLine

##### options.blankLine.property
Type: `Boolean`
Default value: `true`

##### options.blankLine.close
Type: `Boolean`
Default value: `true`

#### options.whiteSpace

##### options.whiteSpace.selector
Type: `Boolean`
Default value: `true`

##### options.whiteSpace.property
Type: `Boolean`
Default value: `true`

#### options.order
Type: `Boolean`
Default value: `true`

#### options.lang
Type: `String`
Default value: `'en'`

#### options.debug
Type: `Boolean`
Default value: `false`

### Usage Examples

#### Default Options

```js
grunt.initConfig({
  sass_format: {
    files: {
      ['src/target1.scss', 'src/target2.scss'],
    },
  },
});
```

#### Custom Options

```js
grunt.initConfig({
  sass_format: {
    options: {
      indentChar:' '
      indentStep:4
    },
    files: {
      ['src/target1.scss', 'src/target2.scss'],
    },
  },
});
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
* 2014-03-23   v0.0.1   first release.
* 2014-03-24   v0.0.3   Modify package.json
* 2014-03-26   v0.0.4   Modify message to English.
