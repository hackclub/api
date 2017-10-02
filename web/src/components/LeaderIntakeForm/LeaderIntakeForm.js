import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { sortBy } from 'lodash'
import {
  Button,
  Emoji,
  TextField,
  TextAreaField,
  SelectField
} from 'components'
import leaderIntakeValidation from './leaderIntakeValidation'

class LeaderIntakeForm extends Component {
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
        return (
          <span>
            Shucks <Emoji type="face_with_open_mouth_and_cold_sweat" />
          </span>
        )
      case 'success':
        return (
          <span>
            Submitted. You're all set! <Emoji type="balloon" />
          </span>
        )
      default:
        return 'Submit'
    }
  }

  render() {
    const { handleSubmit, status, clubs } = this.props

    const clubOptions =
      clubs === undefined ? (
        <option>Loading...</option>
      ) : (
        sortBy(clubs, 'name').map(c => (
          <option value={c.id} key={c.id}>
            {c.name}
          </option>
        ))
      )

    return (
      <form onSubmit={handleSubmit}>
        <Field name="name" label="First and last name" component={TextField} />
        <Field
          name="email"
          type="email"
          label="Email Address"
          description="The email you used when signing up for Slack"
          placeholder="Preferred Email"
          component={TextField}
        />
        <Field name="club_id" label="School" component={SelectField}>
          <option />
          {clubOptions}
        </Field>
        <Field name="gender" label="Gender" component={SelectField}>
          <option />
          <option value="9002">Female</option>
          <option value="9001">Male</option>
          <option value="9003">Other</option>
        </Field>
        <Field name="year" label="Graduation Year" component={SelectField}>
          <option />
          <option value="9009">2022</option>
          <option value="9006">2021</option>
          <option value="9001">2020</option>
          <option value="9002">2019</option>
          <option value="9003">2018</option>
          <option value="9004">2017</option>
          <option value="9010">2016</option>
        </Field>
        <Field name="phone_number" label="Phone number" component={TextField} />
        <Field
          name="github_username"
          label="GitHub username"
          component={TextField}
        />
        <Field
          name="twitter_username"
          label="Twitter username (if you have one)"
          component={TextField}
        />
        <Field
          name="address"
          label="Full address (include state and zip code)"
          component={TextAreaField}
        />
        <Button type="form" state={this.buttonState()}>
          {this.buttonText(status)}
        </Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'leaderIntakeForm',
  validate: leaderIntakeValidation
})(LeaderIntakeForm)
