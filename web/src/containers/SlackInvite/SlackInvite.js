import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'

import colors from 'styles/colors'

import { connect } from 'react-redux'
import * as slackInviteActions from 'redux/modules/slackInvite'
import { SubmissionError } from 'redux-form'

import exampleSlackEmail from './example_slack_email.gif'
import slackValidationPage from './slack_validation_page.jpg'

import {
  Button,
  Card,
  Emoji,
  Header,
  Heading,
  Link,
  Text,
  SlackInviteForm,
  Subtitle,
} from '../../components'

const styles = {
  heading: {
    color: colors.bg,
  },
  subtitle: {
    marginTop: '15px',
  },
  instructions: {
    fontSize: '22px',
    marginTop: '20px',
    color: colors.bg,
  },
  card: {
    marginTop: '20px',
    marginLeft: 'auto',
    marginRight: 'auto',
  },
  wideCard: {
    maxWidth: '700px',
  },
  image: {
    width: '100%',
    boxShadow: `0px 1px 50px -15px ${colors.gray}`,
    border: `1px solid ${colors.outline}`,
  }
}

class SlackInvite extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired,
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.email, values.username, values.full_name, values.password)
      .then(response => {
        this.setState({
          slackInviteID: response
        })
      })
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  content() {
    const { status } = this.props

    if (status !== "success") {
      return (
        <Card style={styles.card}>
          <SlackInviteForm
            status={status}
            onSubmit={values => this.handleSubmit(values)} />
          <Subtitle style={styles.subtitle}>
            Already have an account? Go directly to <Link href="//hackclub.slack.com">Slack</Link>.
          </Subtitle>
        </Card>
      )
    } else {
      return (
        <Card style={[styles.card,styles.wideCard]}>
          <Button type="form" state={status}>Success! <Emoji type="party_popper"/></Button>
          <Text>We're generating an account on Slack for you. Once we get it set up, we'll transfer it to your account email.</Text>
          <Heading>Here's the next step to join:</Heading>
          <Text>You'll get an email in the next few minutes from Slack. Click this button:</Text>
          <img style={styles.image} src={exampleSlackEmail}/>
          <Text>You'll get taken to a page that looks like this:</Text>
          <img style={styles.image} src={slackValidationPage}/>
        </Card>
      )
    }
  }

  render() {
    const { status } = this.props

    const emoji = (function() {
      switch(status) {
        case "success":
          return "slightly_smiling_face"
        case "error":
          return "slightly_frowning_face"
        default:
          return "face_without_mouth"
      }
    })()

    return (
      <div>
        <Helmet title="Slack Invite" />

        <Header>
          <Heading>
            <Emoji type={emoji} />
          </Heading>

          <Heading style={styles.heading}>Join the Hack Club Slack!</Heading>

          <Text style={styles.instructions}>
            Provide us with some information, and we'll generate an account for you!
          </Text>
        </Header>

          {this.content()}
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.slackInvite.status
})

export default connect(
  mapStateToProps,
  {...slackInviteActions}
)(Radium(SlackInvite))
