path        = require 'path'
fs          = require 'fs'
coffee      = require 'coffee-script'

# internal compile shortcut
compile = (fileName) ->
  switch path.extname(fileName)
    when '.js'
      fs.readFileSync(fileName, 'utf8')
    when '.coffee'
      coffee.compile(fs.readFileSync(fileName, 'utf8'),{bare:true}) # all coffee files must be wrapped later
    else
      throw new Error("file: #{fileName} does not have a valid javascript/coffeescript extension")

# simple fs extension to check if a file exists [used to verify require calls' validity]
exists = (file) ->
  try
    fs.statSync(file)
    return true
  catch e
    return false

# avoids pulling in test dependencies and test code
cutTests = (code) -> code.replace(/\n.*require.main[\w\W]*$/, '')
#TODO:? this can eventually use burrito if popular, but for now this is fine.

module.exports =
  compile     : compile
  exists      : exists
  cutTests    : cutTests

