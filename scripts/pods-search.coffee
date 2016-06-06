# Description:
#   Pods.io Search allows IRC users to search Pods.io easily
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .search <search> - Displays the first search result from Pods.io Docs for the searched phrase
#
# Author:
#   pmgarman

searchURL = 'pods.io/docs/'
searchBase = 'https://www.googleapis.com/customsearch/v1?cx=018336167779169652526%3A-8na6q15ruy&key=AIzaSyCRgsgxFW-4S1APoDXZC19Vd2s8oZWLUfY&q='

module.exports = (robot) ->
  robot.hear /\.search (.+)$/i, (msg) ->
    phrase = msg.match[1]
    search = searchBase + encodeURIComponent phrase
    console.log 'Searching Pods.io for: ' + phrase
    console.log 'Searching with: ' + search
    msg
      .http(search)
      .get() (err, res, body) ->
        try
          response = JSON.parse body
          if response.responseData isnt 'null'
            msg.send response.responseData.results[0].titleNoFormatting.replace( ' | Pods Framework', '' ) + ' - ' + response.responseData.results[0].url
          else
            msg.send 'No results found.'
        catch
          msg.send 'Something went wrong... I may have logged it... maybe not though...'
