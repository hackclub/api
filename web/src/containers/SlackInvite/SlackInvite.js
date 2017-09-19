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

  constructor(props) {
    super(props)

    this.pollForUpdate = this.pollForUpdate.bind(this)
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.email, values.username, values.full_name, values.password)
      .then(response => {
        this.setState({
          id: response.id,
          email: response.temp_email,
          inviteState: response.state,
        })
      })
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  pollForUpdate() {
    const { id } = this.state
    fetch(`${config.apiBaseUrl}/v1/slack_invitation/invite/${id}`)
      .then(response => {
        return response.json()
      })
      .then(json => {
        this.setState({
          inviteState: json.state
        })
      })
      .catch(err => console.error(err))
  }

  content() {
    const { status } = this.props
    const { email, inviteState } = this.state

    switch(inviteState) {
      case undefined:
        return (<SlackInviteFormWrapper status={status}
                                        onSubmit={values => this.handleSubmit(values)}/>)
      case 'changed_email':
        return (<SlackInviteInstructions inviteEmail={email} />)
      default:
        return (<SlackInviteLoading poll={this.pollForUpdate} inviteState={inviteState} />)
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
