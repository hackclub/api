import React, { Component } from 'react'
import { reduxForm } from 'redux-form'
import { Button, TextField } from '../../components'
import cloud9SetupValidation from './cloud9SetupValidation'

const styles = {
  emoji: {
    fontSize: '22px',
    lineHeight: 0
  }
}

class Cloud9SetupForm extends Component {
  render() {
    const {
      handleSubmit,
      invalid,
      showFailure,
      style,
      submitting
    } = this.props

    return (
      <form style={style} onSubmit={handleSubmit}>
        <TextField name="email" label="Email" />
        <Button type="form"
                loading={submitting}
                disabled={invalid}>
          {
            showFailure ?
              <span style={styles.emoji}>🤔</span> :
              "Get An Invite"
          }
        </Button>
      </form>
    )
  }
}

export default reduxForm({
  form: 'cloud9SetupForm',
  validate: cloud9SetupValidation
})(Cloud9SetupForm)
