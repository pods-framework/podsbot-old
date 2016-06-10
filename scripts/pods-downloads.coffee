# Description:
#   Pods plugin download count from WP.org
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .count - Displays the plugin download count for Pods
#
# Author:
#   sc0ttkclark

pluginName = 'Pods'
pluginSlug = 'pods'
pluginInfoUrl = 'https://api.wordpress.org/plugins/info/1.0/' + pluginSlug + '.json'

module.exports = (robot) ->
  robot.hear /\.count$/i, (msg) ->
    msg
      .http(pluginInfoUrl)
      .get() (err, res, body) ->
        try
          response = JSON.parse body
          if response.downloaded isnt 'null'
            msg.send pluginName + ' Current Version: ' + response.version + '; Total Downloads: ' + response.downloaded
          else
            msg.send 'No download info found.'
        catch
          msg.send 'WP.org plugin api error'
