import React, { Component } from 'react'
import { Field } from 'redux-form'
import colors from '../../colors'

const styles = {
  formGroup: {
    marginBottom: '15px'
  },
  label: {
    display: 'block',
    marginBottom: '5px',
    fontSize: '18px',
    fontWeight: 'bold'
  },
  input: {
    fontFamily: 'inherit',
    fontSize: '16px',
    color: colors.userInput,
    width: '100%',
    boxSizing: 'border-box',
    display: 'block',
    paddingTop: '7px',
    paddingLeft: '6px',
    paddingRight: '6px',
    paddingBottom: '6px',
    borderRadius: '3px',
    border: `1px solid ${colors.outline}`
  }
}

const renderField = ({ input, label, type, meta: { touched, error } }) => (
  <div style={styles.formGroup}>
    <label style={styles.label}>{label}</label>
    <div>
      <input {...input} placeholder={label} type={type} style={styles.input} />
      { touched && error && <span>{error}</span>}
    </div>
  </div>
)

class TextField extends Component {
  render() {
    const { name, type, label } = this.props

    return (
      <Field name={name} type={type} component={renderField} label={label} />
    )
  }
}

TextField.defaultProps = {
  type: 'text'
}

export default TextField
