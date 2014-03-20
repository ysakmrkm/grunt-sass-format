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

      errMsg = []
      okMsg = []
      indentChar = '\t'
      indentStep = 1


      #インデントチェック
      #!!要改良!!
      indentCheck =
        (indent,txt)->
          indent = indent
          text = txt

          #console.log indent

          if indent is 0
            if /^[ \t]{1,}/.test(text)
              errMsg.push('インデントあり')

          else
            #タブ
            if /^[^ \t]+/.test(text)
              errMsg.push('インデント無し')
            if /^[\t]{1,}/.test(text)
              okMsg.push('インデントがタブ')
            #ホワイトスペース
            if /^[ ]{1,}/.test(text)
              okMsg.push('インデントがホワイトスペース')

            #インデント個数チェック
            regex = new RegExp('^(['+indentChar+']{'+indentStep+','+indentStep+'}){1,}[^ \t]')

            if regex.test(text)
              okMsg.push('インデント'+indentStep+'個')
            else
              errMsg.push('インデント指定通りじゃない')

      ## Iterate over all specified file groups.
      #this.files.forEach(
      files.forEach(
        (f) ->
          #console.log f
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
            line = 1
            indent = 0
            #msg = ''

            fs.readFileSync(f).toString().split('\n').forEach(
              (txt) ->
                text.push(txt)
            )

            #console.log text

            for i in [0..text.length-1]
              errMsg = []
              okMsg = []

              #セレクタ記述
              if /^([ \t]+)?.*[{,]([ \t]+)?$/.test(text[i])

                # セレクタ前インデントチェック
                indentCheck(indent,text[i])

                # セレクタ後スペース有無チェック
                if /[^ ][ ][{,]$/.test(text[i])
                  okMsg.push('セレクタ後スペース有り')
                if /[^ ][ ]{2,}[{,]$/.test(text[i])
                  errMsg.push('セレクタ後スペース多い')
                if /[^ ][{,]$/.test(text[i])
                  errMsg.push('スセレクタ後ペースなし')

                # セレクタ並び方チェック
                if /^[^,]+[{,]$/.test(text[i])
                  okMsg.push('1行1プロパティ')
                if /^([^,]+,){1,}[^,{]+{$/.test(text[i])
                  errMsg.push('1行に複数ある')

                # セレクタ記述終了
                if /^([ \t]+)?.*{([ \t]+)?$/.test(text[i])
                  indent++

              #セレクタ記述
              if /^[^;]+;$/.test(text[i])


                indentCheck(indent,text[i])

                #コロンの後のスペース
                if /: /.test(text[i])
                  okMsg.push('コロン後スペース有り')
                if /:[^ ]/.test(text[i])
                  errMsg.push('コロン後スペース無し')

              if /^([ \t]+)?.*}([ \t]+)?$/.test(text[i])


                #閉じ括弧の後に空白行
                if /^$/.test(text[i+1])
                  okMsg.push('閉じ括弧後空白行有り')
                if /}/.test(text[i+1])
                else
                  errMsg.push('閉じ括弧後空白行無し')
                
                indent--

              console.log line+': '+text[i]
              if grunt.log.wordlist(okMsg).length > 0
                grunt.log.ok grunt.log.wordlist(okMsg,{color:'green'})
              if grunt.log.wordlist(errMsg).length > 0
                grunt.log.error grunt.log.wordlist(errMsg,{color:'red'})

              line++


                #grunt.log.ok 'end:'+indent+'===================='
            #fs.readFileSync(f).toString().split('\n').forEach(
            #  (txt) ->
            #text.forEach(
            #  (txt) ->
            #    if /^([ \t]+)?.*[{,]([ \t]+)?$/.test(txt)
            #      grunt.log.warn 'start:'+indent+'===================='

            #      # 


            #      if /^([ \t]+)?.*{([ \t]+)?$/.test(txt)
            #        indent++

            #      if /[ ][{,]$/.test(txt)
            #        grunt.log.ok 'スペース有り'
            #      if /[ ]{2,}[{,]$/.test(txt)
            #        grunt.log.warn '!スペース多い!'
            #      if /[^ ][{,]$/.test(txt)
            #        grunt.log.warn '!スペースなし!'

            #      console.log line+': '+txt
            #    #console.log line+': '+txt
            #    #text.push(txt)
            #    line++

            #    if /^([ \t]+)?.*}([ \t]+)?$/.test(txt)
            #      indent--
            #      grunt.log.ok 'end:'+indent+'===================='
            #)

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
