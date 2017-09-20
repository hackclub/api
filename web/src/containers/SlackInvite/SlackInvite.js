import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { withRouter } from 'react-router'

import colors from 'styles/colors'

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
    const { router, submit } = this.props

    return submit(values.email, values.username, values.full_name, values.password)
      .then(response => {
        router.push(`/slack_invite/${response.id}`)
      })
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  content() {
    const { params, status } = this.props

    if (params.id) {
      return (<SlackInviteInstructions id={params.id} />)
    } else {
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
)(withRouter(Radium(SlackInvite)))
