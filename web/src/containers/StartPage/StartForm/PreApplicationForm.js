import React from 'react'
import {
  Text,
  Button,
  SelectField,
} from 'components'
import { createValidator, required } from 'utils/validation'

import { reduxForm, Field } from 'redux-form'
import { personTypes } from 'redux/modules/application'

const PreApplicationForm = (props) => {
  const { handleSubmit, invalid } = props
  const buttonState = invalid ? "disabled" : null

  return (
    <form onSubmit={handleSubmit}>
      <Text>I am a...</Text>
      <Field name="person_type" component={SelectField}>
        <option></option>
        <option value={personTypes.student}>Student</option>
        <option value={personTypes.teacher}>Teacher</option>
        <option value={personTypes.parent}>Parent</option>
        <option value={personTypes.other}>Other</option>
      </Field>
      <Button type="form" state={buttonState}>Continue</Button>
    </form>
  )

}

export default reduxForm({
  form: 'preApplicationForm',
  validate: createValidator({
    person_type: [required]
  })
})(PreApplicationForm)
