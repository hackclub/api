import React from 'react'
import { Text, Link } from 'components'

const OauthFailure = () => {
  return (
    <div>
      <Text>
        Oh snap! You didn't give us permission to add hackbot to your Slack.
      </Text>
      <Link to="/hackbot/teams/new">Try again?</Link>
    </div>
  )
}

export default OauthFailure
