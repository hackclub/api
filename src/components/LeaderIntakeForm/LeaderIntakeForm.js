import React, { Component } from 'react'
import { reduxForm } from 'redux-form'
import { Button, Field } from '../../components'
import leaderIntakeValidation from './leaderIntakeValidation'

class LeaderIntakeForm extends Component {
  render() {
    const { handleSubmit, invalid, submitting } = this.props

    return (
      <form onSubmit={handleSubmit}>
        <Field name="name" type="text" label="First and last name" />
        <Field name="email" type="text" label="Preferred email" />
        <Field name="phone_number" type="text" label="Phone number" />
        <Field name="slack_username" type="text" label="Slack username" />
        <Field name="github_username" type="text" label="GitHub username" />
        <Field name="twitter_username" type="text" label="Twitter username (if you have one)" />
        <Field name="address" type="text" label="Full address (include state and zip code)" />
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
