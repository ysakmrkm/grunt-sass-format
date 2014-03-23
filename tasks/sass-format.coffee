###
# grunt-sass-format
# https://github.com/ysakmrkm/grunt-sass-format
#
# Copyright (c) 2014 ysakmrkm
# Licensed under the MIT license.
###
#
'use strict'

merge =
  (obj1, obj2)->
    if !obj2
      obj2 = {}
    for attr of obj2
      if obj2.hasOwnProperty(attr)
        obj1[attr] = obj2[attr];

module.exports = (grunt) ->

  defaultOptions = {
    indentChar:'\t'
    indentStep:1
    blankLine:
      property:true
      close:true
    whiteSpace:
      selector:true
      property:true
    order:true
    debug:false
  }

  grunt.registerTask('sassFormat', 'Check format of sass you wish.',
    () ->
      options = {}

      config = grunt.config('sassFormat')
      options = defaultOptions
      merge(options,config.options)
      files = config.files

      errMsg = []
      okMsg = []

      indentChar = options.indentChar
      indentStep = options.indentStep

      #インデントチェック
      checkIndent =
        (indent,txt)->
          indent = indent
          text = txt

          if indent is 0
            regex = new RegExp('^['+indentChar+']+')
            if regex.test(text)
              errMsg.push('インデントあり')

          else
            regex = new RegExp('^[^'+indentChar+']+')
            if regex.test(text)
              errMsg.push('インデント無し')

            #インデント個数チェック
            #step = new RegExp('^(['+indentChar+']{'+indentStep+','+(indentStep * indent)+'}){1,}[^ \t]')
            step = new RegExp('^(['+indentChar+']{'+(indentStep * indent)+'})[^'+indentChar+']')

            if step.test(text)
              okMsg.push('インデント'+(indentStep * indent)+'個')
            else
              errMsg.push('インデント指定通りじゃない')


      #空白行チェック
      checkBlankLine =
        (indent,txt)->
          indent = indent
          text = txt

          if /^$/.test(text)
            okMsg.push('空白行有り')
          else
            regex = new RegExp('^(['+indentChar+']{'+(indentStep * indent)+'}){1,}({|[^{]+[,{])')
            if regex.test(text)
              errMsg.push('空白行無し')

      # セレクタ/コロン後スペース有無チェック
      checkWhiteSpace =
        (mode,txt)->
          mode = mode
          text = txt

          if mode == 'selector'
            if /[^ ][ ][,{]$/.test(text)
              okMsg.push('セレクタ後スペース有り')
            if /[^ ][ ]{2,}[,{]$/.test(text)
              errMsg.push('セレクタ後スペース多い')
            if /[^ ][,{]$/.test(text)
              errMsg.push('セレクタ後スペースなし')
          if mode == 'property'
            if /: /.test(text)
              okMsg.push('コロン後スペース有り')
            if /:[^ ]/.test(text)
              errMsg.push('コロン後スペース無し')

      # セレクタ並び方チェック
      checkOrder =
        (txt)->
          text = txt

          if /^[^,]+[,{]$/.test(text)
            okMsg.push('1行1プロパティ')
          if /^([^,]+,){1,}[^,{]+{$/.test(text)
            errMsg.push('1行に複数ある')

      files.forEach(
        (f) ->
          if !grunt.file.exists(f)
            grunt.log.warn('Source file "' + f + '" not found.')
            return false
          else
            grunt.log.ok('Source file "' + f + '" found.')
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

            text.pop()

            for i in [0..text.length-1]
              errMsg = []
              okMsg = []

              #セレクタ記述
              if /^([ \t]+)?.*[,{]([ \t]+)?$/.test(text[i])

                # セレクタ前インデントチェック
                if options.indent
                  checkIndent(indent,text[i])

                # セレクタ後スペース有無チェック
                if options.whiteSpace.selector
                  checkWhiteSpace('selector',text[i])

                # セレクタ並び方チェック
                if options.order
                  checkOrder(text[i])

                # セレクタ記述終了
                if /^([ \t]+)?.*{([ \t]+)?$/.test(text[i])
                  indent++

              #プロパティ記述
              if /^[^;]+;$/.test(text[i])

                if options.indent
                  checkIndent(indent,text[i])

                if options.whiteSpace.property
                  checkWhiteSpace('property',text[i])

                if options.blankLine.property
                  checkBlankLine(indent,text[i+1])

              #閉じカッコ
              if /^([ \t]+)?.*}([ \t]+)?$/.test(text[i])

                if options.blankLine.close
                  checkBlankLine(indent,text[i+1])

                indent--


              if options.debug
                if grunt.log.wordlist(okMsg).length > 0
                  console.log line+': '+text[i]
                  grunt.log.ok grunt.log.wordlist(okMsg,{color:'green'})
              if grunt.log.wordlist(errMsg).length > 0
                console.log line+': '+text[i]
                grunt.log.error grunt.log.wordlist(errMsg,{color:'red'})

              line++
      )
  )
