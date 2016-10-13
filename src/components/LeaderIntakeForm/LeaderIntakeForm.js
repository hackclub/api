import React, { Component } from 'react'
import { reduxForm } from 'redux-form'
import { Button, TextField } from '../../components'
import leaderIntakeValidation from './leaderIntakeValidation'

class LeaderIntakeForm extends Component {
  buttonState() {
    const { submitting, invalid, status } = this.props

    if (invalid) {
      return "disabled"
    } else if (submitting) {
      return "loading"
    } else {
      return status
    }
  }

  buttonText(status) {
    switch(status) {
    case "error":
      return "Shucks :-/"
    case "success":
      return "You're all set!"
    default:
      return "Submit"
    }
  }

  render() {
    const { handleSubmit, status } = this.props

    return (
      <form onSubmit={handleSubmit}>
        <TextField name="name" label="First and last name" />
        <TextField name="email" type="email" label="Preferred email" />
        <TextField name="phone_number" label="Phone number" />
        <TextField name="slack_username" label="Slack username" />
        <TextField name="github_username" label="GitHub username" />
        <TextField name="twitter_username" label="Twitter username (if you have one)" />
        <TextField name="address" label="Full address (include state and zip code)" />
        <Button type="form"
                state={this.buttonState()}>{this.buttonText(status)}</Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'leaderIntakeForm',
  validate: leaderIntakeValidation
})(LeaderIntakeForm)
