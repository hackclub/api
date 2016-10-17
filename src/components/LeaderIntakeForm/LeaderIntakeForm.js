import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { Button, TextField, TextAreaField, SelectField } from '../../components'
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
        <Field name="name" label="First and last name" component={TextField} />
        <Field name="email" type="email" label="Preferred email" component={TextField} />
        <Field name="gender" label="Gender" component={SelectField}>
          <option></option>
          <option value="Female">Female</option>
          <option value="Male">Male</option>
          <option value="Other">Other</option>
        </Field>
        <Field name="year" label="Year" component={SelectField}>
          <option></option>
          <option value="2022">2022</option>
          <option value="2021">2021</option>
          <option value="2020">2020</option>
          <option value="2019">2019</option>
          <option value="2018">2018</option>
          <option value="2017">2017</option>
          <option value="2016">2016</option>
        </Field>
        <Field name="phone_number" label="Phone number" component={TextField} />
        <Field name="slack_username" label="Slack username" component={TextField} />
        <Field name="github_username" label="GitHub username" component={TextField} />
        <Field name="twitter_username" label="Twitter username (if you have one)" component={TextField} />
        <Field name="address" label="Full address (include state and zip code)" component={TextAreaField} />
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
