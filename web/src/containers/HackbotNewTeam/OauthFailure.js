import React, { Component } from 'react'
import { Text, Link } from 'components'

class OauthFailure extends Component {
  render() {
    return (
      <div>
        <Text>
          Oh snap! You didn't give us permission to add hackbot to your Slack.
        </Text>
        <Link to="/hackbot/teams/new">Try again?</Link>
      </div>
    )
  }
}

export default OauthFailure
