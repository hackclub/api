import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'

import colors from 'styles/colors'
import config from 'config'

import { connect } from 'react-redux'
import * as slackInviteActions from 'redux/modules/slackInvite'
import { SubmissionError } from 'redux-form'

import {
  Emoji,
  Header,
  Heading,
  Text,
} from 'components'

import SlackInviteInstructions from './SlackInviteInstructions/SlackInviteInstructions'
import SlackInviteFormWrapper from './SlackInviteFormWrapper/SlackInviteFormWrapper'
import SlackInviteLoading from './SlackInviteLoading/SlackInviteLoading'

const styles = {
  heading: {
    color: colors.bg,
  },
  instructions: {
    fontSize: '22px',
    marginTop: '20px',
    color: colors.bg,
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
          inviteID: response.id,
          email: response.email,
          inviteState: response.state,
        })
      })
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  pollForUpdate() {
    const { inviteID } = this.state

    fetch(`${config.apiBaseUrl}/v1/slack_invitation/invite/${inviteID}`)
      .then(response => {
        return response.json()
      })
      .then(json => {
        this.setState({
          inviteState: json.state
        })
      })
      .catch(error => console.error(error))
  }

  content() {
    const { status } = this.props
    const { inviteEmail, inviteState } = this.state

    switch(inviteState) {
      case 'invited':
        return (<SlackInviteLoading interval={this.pollForUpdate} />)
      case 'changed_email':
        return (<SlackInviteInstructions inviteEmail={inviteEmail} />)
      default:
        return (<SlackInviteFormWrapper status={status}
                                        onSubmit={values => this.handleSubmit(values)}/>)
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
