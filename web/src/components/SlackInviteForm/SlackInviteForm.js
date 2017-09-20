import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import {
  Button,
  Emoji,
  TextField
} from 'components'

import slackInviteValidation from './slackInviteValidation'

class SlackInviteForm extends Component {
  buttonState() {
    const {
      submitting,
      invalid,
      status
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
      return (<span>Check your email for an invitation to your Slack account! <Emoji type="fisted_hand_sign" /></span>)
    default:
      return "Get Your Hack Club Slack Account"
    }
  }

  render() {
    const { handleSubmit, style, status } = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <Field name="email" label="Email" placeholder="orpheus@hackclub.com" component={TextField} />
        <Field name="username" label="Username" placeholder="proforpheus" component={TextField} />
        <Field name="full_name" label="Full name" placeholder="Prophet Orpheus" component={TextField} />
        <Field name="password" label="Password" placeholder="LastDinosaur" component={TextField} type="password"/>

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
