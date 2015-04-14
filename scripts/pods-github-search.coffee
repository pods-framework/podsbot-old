# Description:
#   Pods GitHub Issue Search allows IRC users to search Pods GitHub Issues
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .findissue <search> - Displays the first two search results from Pods GitHub Issues for the searched phrase
#
# Author:
#   pmgarman

searchURL = 'github.com/pods-framework/pods/issues'
searchBase = 'https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=site:' + searchURL

module.exports = (robot) ->
  robot.hear /\.findissue (.+)$/i, (msg) ->
    phrase = msg.match[1]
    search = searchBase + '%20' + encodeURIComponent phrase
    console.log 'Searching Pods GitHub Issues for: ' + phrase
    console.log 'Searching with: ' + search
    msg
      .http(search)
      .get() (err, res, body) ->
        try
          response = JSON.parse body

          if response.responseData is 'null'
            msg.send 'No results found.'
          else
            found = response.responseData.results[0].titleNoFormatting.replace( new RegExp( '/\s\u00B7\spods\-framework.*/' ), '' )
            msg.send found + ' - ' + response.responseData.results[0].url
            if response.responseData.results[1].url isnt 'undefined'
              found2 = response.responseData.results[1].titleNoFormatting.replace( new RegExp( '/\s\u00B7\spods\-framework.*/' ), '' )
              msg.send found2 + ' - ' + response.responseData.results[1].url

        catch
          return