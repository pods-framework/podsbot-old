# Description:
#   WP Codex Search allows IRC users to search the WP codex easily
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .codex <search> - Displays the first search result from the WP Codex for the searched phrase
#
# Author:
#   pmgarman

codexURL = 'codex.wordpress.org'
searchBase = 'https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=site:' + codexURL + '%20'

module.exports = (robot) ->
  robot.hear /\.codex (.+)$/i, (msg) ->
    phrase = msg.match[1]
    search = searchBase + encodeURIComponent phrase
    console.log 'Searching WP Codex for: ' + phrase
    console.log 'Searching with: ' + search
    msg
      .http(search)
      .get() (err, res, body) ->
        try
          response = JSON.parse body
          if response.responseData isnt 'null'
            msg.send response.responseData.results[0].titleNoFormatting + ' - ' + response.responseData.results[0].url
          else
            msg.send 'No results found.'
        catch
          msg.send 'Something went wrong... I may have logged it... maybe not though...'