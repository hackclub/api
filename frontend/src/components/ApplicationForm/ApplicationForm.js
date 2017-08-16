import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { Button, Emoji, Link, TextField, TextAreaField, SelectField } from '../../components'
import applicationValidation from './applicationValidation'

const monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
]

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

  next12Months() {
    const genMonth = (date) => {
      const month = monthNames[date.getMonth()]

      const label = `${month} ${date.getFullYear()}`
      const iso = date.toISOString()

      return { label, iso }
    }

    var months = []
    var today = new Date()

    var asap = genMonth(today);
    asap.label = "ASAP"

    months.push(asap)

    for (var i = 0; i < 12; i++) {
      today.setMonth(today.getMonth() + 1)

      months.push(genMonth(today))
    }

    return months
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
    const { handleSubmit, style, status} = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <Subtitle>Information</Subtitle>

        <Field name="first_name" label="First name" placeholder="Fiona" component={TextField} />
        <Field name="last_name" label="Last name" placeholder="Hackworth" component={TextField} />
        <Field name="email" type="email" label="Preferred email" placeholder="fiona@hackworth.com" component={TextField} />
        <Field name="phone_number" label="Phone number" placeholder="(555) 555 5555" component={TextField} />
        <Field name="high_school" label="High school" placeholder="Atlantis High School" component={TextField} />

        <Field name="year" label="When do you graduate high school?" component={SelectField}>
          <option value="9010">Other</option>
          <option value="9001">2022</option>
          <option value="9002">2021</option>
          <option value="9003">2020</option>
          <option value="9004">2019</option>
          <option value="9005">2018</option>
          <option value="9006">2017</option>
          <option value="9007">2016</option>
          <option value="9009">Teacher</option>
          <option value="9008">Graduated</option>
        </Field>

        <Field name="github" label="GitHub" placeholder="FionaHackworth" component={TextField} />
        <Field name="twitter" label="Twitter" placeholder="fionahack" component={TextField} />

        <Field name="start_date" label="When do you want to start your club?" component={SelectField}>
          { this.next12Months().map(month => {
            return (<option value={month.iso} key={month.iso}>{month.label}</option>)
          })}
        </Field>

        <Subtitle>Application</Subtitle>

        <Field name="interesting_project" label="Please tell us about an interesting project, preferably outside of class, that you created or worked on." component={TextAreaField} />

        <Field name="systems_hacked" label={<span>Please tell us about the time you most successfully hacked some (non-computer) system to your advantage. <Link href="https://www.quora.com/When-have-you-most-successfully-hacked-a-non-computer-system-to-your-advantage">Click here</Link> for the sorts of responses we're looking for.</span>} component={TextAreaField} />

        <Field name="steps_taken" label="What steps have you taken so far in starting your club?" component={TextAreaField} />

        <Field name="referer" label="How did you hear about us?" component={TextField} placeholder="" />

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
