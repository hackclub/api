import React, { Component } from 'react'
import { reduxForm } from 'redux-form'
import { Button, TextField } from '../../components'
import leaderIntakeValidation from './leaderIntakeValidation'

class LeaderIntakeForm extends Component {
  render() {
    const { handleSubmit, invalid, submitting } = this.props

    return (
      <form onSubmit={handleSubmit}>
        <TextField name="name" type="text" label="First and last name" />
        <TextField name="email" type="text" label="Preferred email" />
        <TextField name="phone_number" type="text" label="Phone number" />
        <TextField name="slack_username" type="text" label="Slack username" />
        <TextField name="github_username" type="text" label="GitHub username" />
        <TextField name="twitter_username" type="text" label="Twitter username (if you have one)" />
        <TextField name="address" type="text" label="Full address (include state and zip code)" />
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
