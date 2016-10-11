import React, { Component } from 'react'
import { reduxForm } from 'redux-form'
import { Button, TextField } from '../../components'
import leaderIntakeValidation from './leaderIntakeValidation'

class LeaderIntakeForm extends Component {
  render() {
    const { handleSubmit, invalid, submitting } = this.props

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
                loading={submitting}
                disabled={invalid}>Submit</Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'leaderIntakeForm',
  validate: leaderIntakeValidation
})(LeaderIntakeForm)
