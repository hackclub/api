import React, { Component } from 'react'
import config from '../../config'
import { Button } from '../../components'

class LoginPrompt extends Component {
  render() {
    const baseAuthUrl = "https://slack.com/oauth/authorize"
    const clientId = config.slackClientId
    const scope = "bot"

    const authUrl = `${baseAuthUrl}?client_id=${clientId}&scope=${scope}`
    return (
      <div>
        <Button type="link" href={authUrl}>Add hackbot to your Slack</Button>
      </div>
    )
  }
}

export default LoginPrompt
