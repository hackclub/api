import React, { Component } from 'react'
import Radium from 'radium'
import { Card, Link, SlackInviteForm, Subtitle } from 'components'

const styles = {
  subtitleBottom: {
    marginTop: '15px'
  },
  subtitleTop: {
    marginBottom: '15px'
  },
  card: {
    marginTop: '20px',
    marginLeft: 'auto',
    marginRight: 'auto'
  }
}
class SlackInviteFormWrapper extends Component {
  render() {
    const { status, onSubmit } = this.props

    return (
      <Card style={styles.card}>
        <Subtitle style={styles.subtitleTop}>
          Already have an account? Go directly to{' '}
          <Link href="//hackclub.slack.com">Slack</Link>.
        </Subtitle>
        <SlackInviteForm status={status} onSubmit={onSubmit} />
        <Subtitle style={styles.subtitleBottom}>
          By filling out this form, you are agreeing to Slack's{' '}
          <Link href="https://slack.com/terms-of-service/user">
            User Terms of Service
          </Link>,{' '}
          <Link href="https://slack.com/privacy-policy">Privacy Policy</Link>,
          and <Link href="https://slack.com/cookie-policy">Cookie Policy</Link>.
        </Subtitle>
      </Card>
    )
  }
}

export default Radium(SlackInviteFormWrapper)
