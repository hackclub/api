import React, { Component } from 'react'
import Radium from 'radium'
import colors from 'styles/colors'
import {
  Button,
  Card,
  Emoji,
  Heading,
  Text,
} from 'components'
import exampleSlackEmail from './example_slack_email.gif'
import slackValidationPage from './slack_validation_page.jpg'

const styles = {
  card: {
    marginTop: '20px',
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '700px',
  },
  email: {
    fontWeight: 600
  },
  text: {
    marginTop: '16px',
  },
  image: {
    width: '100%',
    boxShadow: `0px 1px 50px -15px ${colors.gray}`,
    border: `1px solid ${colors.outline}`,
  }
}

class SlackInviteInstructions extends Component {
  render() {
    const { inviteEmail } = this.props

    return (
      <Card style={[styles.card,styles.wideCard]}>
        <Button type="form" state="success">Success! <Emoji type="party_popper"/></Button>
        <Text style={styles.text}>We're generating an account on Slack for you. Once we get it set up, we'll transfer it to your account email.</Text>
        <Heading>Here's the next step to join:</Heading>
        <Text style={styles.text}>You'll get an email in the next few minutes from Slack. Click this button:</Text>
        <img style={styles.image} src={exampleSlackEmail} alt="Slack email" />
        <Text style={styles.text}>You'll get taken to a page that looks like this:</Text>
        <img style={styles.image} src={slackValidationPage} alt="Slack validation webpage" />
        <Text style={styles.text}>To sign in the first time, you'll need to type in <span style={styles.email}>{inviteEmail}</span> as your email.</Text>
      </Card>
    )
  }
}

export default Radium(SlackInviteInstructions)
