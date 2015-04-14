# Description:
#   Create GitHub Issues on the fly using a generic GitHub user and Hubot
#
#   var a = '-f foo "ds  df s\\" da" -b -a -z baz bar';
#   a
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_CREATE_ISSUE_ALLOWED_USERS
#
# Commands:
#   .issue <json> - Allows for a whitelist of users to create new GitHub issues
#
# Author:
#   pmgarman, sc0ttkclark

module.exports = (robot) ->
  github = require("githubot")(robot)

  githubAllowedUsers = process.env.HUBOT_GITHUB_CREATE_ISSUE_ALLOWED_USERS
  if githubAllowedUsers == undefined
    githubAllowedUsers = "hubot"

  robot.hear /\.issue (.+)$/i, (msg) ->
    if !msg.message.user.name.match(new RegExp(githubAllowedUsers, "gi"))
      msg.send 'No pizza for you!'
      return

    if msg.match[1].match( /\{/ )
      try
        passed = JSON.parse( msg.match[1] )
      catch
        msg.send 'BAD JSON! BAD! JSON YOU ARE GROUNDED!' # Because JSON ~ JASON
        return
    else
        passed = { "title": msg.match[1], "body": msg.match[1] + ' submitted via Slack by ' + msg.message.user.name }

    if typeof passed.title == 'undefined'
      #msg.send 'You did not pass a title, fix your JSON buddy'
      return

    if typeof passed.body == 'undefined'
      passed.body = passed.title;

    data =
      title: passed.title
      body: passed.body

    if typeof passed.assignee != 'undefined'
      data.assignee = passed.assignee

    if typeof passed.labels != 'undefined'
      data.labels = passed.labels

    if typeof passed.milestone != 'undefined'
      data.milestone = passed.milestone

    console.log data

    bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO

    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'

    console.log "#{base_url}/repos/#{bot_github_repo}/issues"

    github.handleErrors (response) ->
      msg.send 'Ruh roh!! ' + response.error
      msg.send response.body.errors

    github.post "#{base_url}/repos/#{bot_github_repo}/issues", data, (issue) ->
        try
          if typeof issue.html_url != 'undefined'
            msg.send issue.html_url
          else
            msg.send 'I got this from GitHub instead of an issue: ' + issue.message
            if data.milestone != 'undefined'
              msg.send 'I suggest making sure the milestone you passed has been created'
        catch
          msg.send 'Something went wrong... I may have logged it... maybe not though...'