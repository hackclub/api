import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'

import colors from '../../styles/colors'

import { connect } from 'react-redux'
import * as slackInviteActions from '../../redux/modules/slackInvite'
import { SubmissionError } from 'redux-form'

import {
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
  }
}

class SlackInvite extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired,
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.email)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
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
            All we need is your email, and we'll be on our way.
          </Text>
        </Header>

        <Card style={styles.card}>
          <SlackInviteForm
            status={status}
            onSubmit={values => this.handleSubmit(values)} />
          <Subtitle style={styles.subtitle}>Already have an account? Go directly to <Link href="//hackclub.slack.com">Slack</Link>.</Subtitle>
        </Card>
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
