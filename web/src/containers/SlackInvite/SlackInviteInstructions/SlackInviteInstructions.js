import React, { Component } from 'react'
import Radium from 'radium'
import colors from 'styles/colors'
import {
  Button,
  Card,
  Emoji,
  Heading,
  Link,
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
        <Text style={styles.text}>Now that we've created an account on Slack for you, we need to transfer the account to you.</Text>
        <Heading>Here's the next step to join:</Heading>
        <Text style={styles.text}>You'll get an email in the next few minutes from Slack. Click this button:</Text>
        <img style={styles.image} src={exampleSlackEmail} alt="Slack email" />
        <Text style={styles.text}>The button will link to page that looks like this:</Text>
        <img style={styles.image} src={slackValidationPage} alt="Slack validation webpage" />
        <Text style={styles.text}>In the future you can sign in with your own account, but to get the account transfered to you this first time, you'll need to use this as your email: <span style={styles.email}>{inviteEmail}</span> (use your regular password with it). Once you sign in, you should have access to <Link href="https://hackclub.slack.com">hackclub.slack.com</Link>.</Text>
      </Card>
    )
  }
}

export default Radium(SlackInviteInstructions)
