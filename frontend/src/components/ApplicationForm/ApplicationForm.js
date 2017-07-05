import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { Button, Emoji, TextField, TextAreaField, SelectField } from '../../components'
import applicationValidation from './applicationValidation'

const subtitleStyles = {
  fontWeight: 300,
  paddingBottom: '8px',
  float: 'right'
}

class Subtitle extends Component {
  render() {
    return (
      <div>
        <div style={{ height: '10px'}} />

        <p style={subtitleStyles}>{this.props.children}</p>

        <div style={{float: 'clear'}}/>
      </div>
    )
  }
}

class ApplicationForm extends Component {
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
      return (<span>Shucks <Emoji type="face_with_open_mouth_and_cold_sweat" /></span>)
    case "success":
      return (<span>You're all set! <Emoji type="balloon" /></span>)
    default:
      return "Submit"
    }
  }

  render() {
    return (
      <form onSubmit={(x) => console.log(x) }>
        <Subtitle>Information</Subtitle>

        <Field name="firstName" label="First name" placeholder="Zaphod" component={TextField} />
        <Field name="lastName" label="Last name" placeholder="Beeblebrox" component={TextField} />
        <Field name="email" type="email" label="Preferred email" placeholder="zaphod@beeblebrox.com" component={TextField} />
        <Field name="phoneNumber" label="Phone number" placeholder="(555) 555 5555" component={TextField} />
        <Field name="highSchool" label="High school" placeholder="Visalia High School" component={TextField} />

        <Field name="year" label="Current year" component={SelectField} >
          <option value="below_high_school"></option>
          <option value="nine">Nine</option>
          <option value="ten">Ten</option>
          <option value="eleven">Eleven</option>
          <option value="twelve">Twelve</option>
          <option value="college_student">College student</option>
          <option value="teacher">Teacher</option>
          <option value="parent">Parent or guardian</option>
          <option value="other">Other</option>
        </Field>

        <Field name="github" label="GitHub" placeholder="Zaphod" component={TextField} />
        <Field name="twitter" label="Twitter" placeholder="Zaphod" component={TextField} />

        <Subtitle>Application</Subtitle>

        <Field name="interestingProject" label="Please tell us about an interesting project, preferably outside of class, that you created or worked on." component={TextAreaField} />

        <Field name="hack" label="Please tell us about the time you most successfully hacked some (non-computer) system to your advantage. Click here for the sorts of responses we're looking for." component={TextAreaField} />

        <Field name="firstSteps" label="What steps have you taken so far in starting your club?" component={TextAreaField} />

        <Field name="referral" label="How did you hear about us?" component={TextField} placeholder="" />

        <Button type="form"
                state={this.buttonState()}>{this.buttonText(status)}</Button>

      </form>
    )
  }
}

export default reduxForm({
  form: 'applicationForm',
  validate: applicationValidation
})(ApplicationForm)
