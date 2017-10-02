import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { Button, Emoji, TextField } from 'components'
import cloud9SetupValidation from './cloud9SetupValidation'

class Cloud9SetupForm extends Component {
  buttonState() {
    const { submitting, invalid, status } = this.props

    if (invalid) {
      return 'disabled'
    } else if (submitting) {
      return 'loading'
    } else {
      return status
    }
  }

  buttonText(status) {
    switch (status) {
      case 'error':
        return <Emoji type="thinking_face" />
      case 'success':
        return (
          <span>
            Invite Sent! Check your email <Emoji type="fisted_hand_sign" />
          </span>
        )
      default:
        return 'Get Your Cloud9 Invite'
    }
  }

  render() {
    const { handleSubmit, style, status } = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <Field name="email" label="Email" component={TextField} />
        <Button type="form" state={this.buttonState()}>
          {this.buttonText(status)}
        </Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'cloud9SetupForm',
  validate: cloud9SetupValidation
})(Cloud9SetupForm)
