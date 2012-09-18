#!/usr/bin/env coffee
express = require "express"
jade = require "jade"
assets = require "connect-assets"
require "jumly-jade"
require "jade-filters"

app = express()
app.set "view engine", "jade"
app.use express.static "#{__dirname}/views/static"
app.use assets src:"lib"

app.get "/", (req,res)->
  res.render "index"

app.listen port = 3000
console.log "Listening at #{port}"
