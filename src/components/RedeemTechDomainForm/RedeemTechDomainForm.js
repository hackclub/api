import React, { Component } from 'react'
import { reduxForm, Field } from 'redux-form'
import { Button, TextField } from '../../components'
import redeemTechDomainValidation from './redeemTechDomainValidation'

class RedeemTechDomainForm extends Component {
  buttonState() {
    const {
      submitting,
      invalid,
      status
    } = this.props

    if (invalid) {
      return "disabled"
    } else if (submitting) {
      return "loading"
    } else {
      return status
    }
  }

  render() {
    const { handleSubmit, style } = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <Field name="name" label="Your Name" placeholder="Arthur Dent" component={TextField} />
        <Field name="email" label="Email" placeholder="arthur@earth.com" component={TextField} />
        <Field name="requested_domain" label="Domain" placeholder="arthurdent.tech" component={TextField} />
        <Field name="secret_code" label="Secret Code" placeholder="Get from your club leader" component={TextField} />
        <Button type="form" state={ this.buttonState() }>
          Get your .TECH domain!
        </Button>
      </form>
    )
  }
}

export default reduxForm({
  validate: redeemTechDomainValidation,
  form: 'redeemTechDomainRedemption'
})(RedeemTechDomainForm)
