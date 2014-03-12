###
# grunt-sass-format
# https://github.com/ysakmrkm/grunt-sass-format
#
# Copyright (c) 2014 ysakmrkm
# Licensed under the MIT license.
###
#
'use strict'

module.exports = (grunt) ->

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks

  #grunt.registerMultiTask('sassFormat', 'Format sass you want.',
  grunt.registerTask('sassFormat', 'Format sass you want.',
    () ->

      # Merge task-specific and/or target-specific options with these defaults.
      #options = this.options(
      #  punctuation: '.'
      #  separator: ', '
      #)

      config = grunt.config('sassFormat')

      files = config.files

      ## Iterate over all specified file groups.
      #this.files.forEach(
      files.forEach(
        (f) ->
          console.log f
          # Concat specified files.
          # Warn on and remove invalid source files (if nonull was set).
          if !grunt.file.exists(f)
            grunt.log.warn('Source file "' + f + '" not found.')
            return false
          else
            grunt.log.ok('Source file "' + f + '" found.')
            #return true
            # Read file source.
            grunt.log.ok('Source file "' + f + '" read.')
            tmp = grunt.file.read(f)
            fs = require('fs')
            text = []
            line = 0
            indent = 0
            fs.readFileSync(f).toString().split('\n').forEach(
              (txt) ->
                if /^([ \t]+)?.*{([ \t]+)?$/.test(txt)
                  grunt.log.warn 'start:'+indent+'===================='
                  indent++

                  if /[ ]{/.test(txt)
                    grunt.log.ok 'スペース有り'
                  else
                    grunt.log.warn '!スペースなし!'

                    console.log line+': '+txt
                #console.log line+': '+txt
                #text.push(txt)
                line++

                if /^([ \t]+)?.*}([ \t]+)?$/.test(txt)
                  indent--
                  grunt.log.ok 'end:'+indent+'===================='
            )

            #console.log text

            #return grunt.file.read(f)
          #src = f.filter(
          #  (filepath) ->
          #    # Warn on and remove invalid source files (if nonull was set).
          #    if !grunt.file.exists(filepath)
          #      grunt.log.warn('Source file "' + filepath + '" not found.')
          #      return false
          #    else
          #      return true
          #).map(
          #  (filepath) ->
          #    # Read file source.
          #    return grunt.file.read(filepath)
          #).join(grunt.util.normalizelf(options.separator))

      #    # Handle options.
      #    src += options.punctuation

      #    # Write the destination file.
      #    grunt.file.write(f.dest, src)

      #    # Print a success message.
      #    grunt.log.writeln('File "' + f.dest + '" created.')
      )
  )
