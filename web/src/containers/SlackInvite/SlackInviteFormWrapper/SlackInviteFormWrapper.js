import React, { Component } from 'react'
import Radium from 'radium'
import {
  Card,
  Link,
  SlackInviteForm,
  Subtitle,
} from 'components'

const styles = {
  subtitle: {
    marginTop: '15px'
  },
  card: {
    marginTop: '20px',
    marginLeft: 'auto',
    marginRight: 'auto',
  }
}
class SlackInviteFormWrapper extends Component {
  render() {
    const { status, onSubmit } = this.props
    return (
      <Card style={styles.card}>
        <SlackInviteForm
          status={status}
          onSubmit={onSubmit} />
        <Subtitle style={styles.subtitle}>
          Already have an account? Go directly to <Link href="//hackclub.slack.com">Slack</Link>.
        </Subtitle>
      </Card>
    )
  }
}

export default Radium(SlackInviteFormWrapper)
