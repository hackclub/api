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
        <Text style={styles.text}>Your temporary email address is <span style={styles.email}>{inviteEmail}</span>. We've created an account for you using the temporary email address and transfered it to your preferred email as. You'll need to use the temporary email the first time you sign into your account. After that, you'll use your preferred email to sign up.</Text>
        <Heading>Here's the next step to join:</Heading>
        <Text style={styles.text}>You'll get an email in the next few minutes from Slack. Click this button:</Text>
        <img style={styles.image} src={exampleSlackEmail} alt="Slack email" />
        <Text style={styles.text}>The button will link to a page that looks like this:</Text>
        <img style={styles.image} src={slackValidationPage} alt="Slack validation webpage" />
        <Text style={styles.text}>Sign in with your temporary email address (<span style={styles.email}>{inviteEmail}</span>) and your password. Once you've done that, you can hop on Slack with your own email address at <Link href="https://hackclub.slack.com">hackclub.slack.com</Link>.</Text>
      </Card>
    )
  }
}

export default Radium(SlackInviteInstructions)
