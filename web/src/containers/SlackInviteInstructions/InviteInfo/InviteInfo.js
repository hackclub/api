import React from 'react'
import colors from 'styles/colors'
import { mediaQueries } from 'styles/common'
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
  image: {
    [mediaQueries.smallUp]: {
      width: '100%',
      marginLeft: 0,
      marginRight: 0,
    },
    [mediaQueries.mediumUp]: {
      width: '50%',
      marginLeft: '25%',
      marginRight: '25%',
    },
    boxShadow: `0px 1px 50px -15px ${colors.gray}`,
    border: `1px solid ${colors.outline}`,
  },
  text: {
    marginTop: '16px',
  },
}

const InviteInfo = ({tempEmail}) => {
  return (
    <Card style={[styles.card,styles.wideCard]}>
      <Text style={styles.text}>Your temporary email address is <span style={styles.email}>{tempEmail}</span>. We've created an account for you using the temporary email and transferred it to your preferred email. You'll need to use the temporary email the first time you sign into your account. After that, you'll use your preferred email to sign up.</Text>
      <Heading>Here's the next step to join:</Heading>
      <Text style={styles.text}>You'll get an email in the next few minutes from Slack. Click this button:</Text>
      <img style={styles.image} src={exampleSlackEmail} alt="Slack email" />
      <Text style={styles.text}>The button will link to a page that looks like this:</Text>
      <img style={styles.image} src={slackValidationPage} alt="Slack validation webpage" />
      <Text style={styles.text}>Sign in with your temporary email address (<span style={styles.email}>{tempEmail}</span>) and your password. Once you've done that, you can use your preferred email address in the future.</Text>
      <Button type="link" state="success" href="https://hackclub.slack.com">
        Head to Slack <Emoji type="rocket" />
      </Button>
    </Card>
  )
}

export default InviteInfo
