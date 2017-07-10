import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import {
  Button,
  Emoji,
  TextField
} from '../../components'

import slackInviteValidation from './slackInviteValidation'

class SlackInviteForm extends Component {
  buttonState(status) {
    const {
      submitting,
      invalid,
      stats
    } = this.props

    if (invalid) {
      return "disabled"
    } else if (submitting) {
      return "loading"
    } else {
      return status
    }
  }

  buttonText(status) {
    switch (status) {
    case "error":
      return (<Emoji type="thinking_face" />)
    case "success":
      return (<span>Invite Sent! Check your email <Emoji type="fisted_hand_sign" /></span>)
    default:
      return "Get Your Hack Club Slack Invite"
    }
  }

  render() {
    const { handleSubmit, style, status } = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <Field name="email" label="Email" placeholder="fiona@hackworth.com" component={TextField} />
        <Button type="form" state={this.buttonState()}>
          {this.buttonText(status)}
        </Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'slackInviteForm',
  validate: slackInviteValidation
})(SlackInviteForm)
