import React from 'react'
import { Field } from 'components'
import colors from 'styles/colors'

const styles = {
  fontFamily: 'inherit',
  fontSize: '16px',
  color: colors.userInput,
  height: '35px',
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

class TextField extends Field {
  renderInput() {
    const { input, label, type, placeholder } = this.props

    return (
      <input {...input}
        placeholder={placeholder === undefined ? label : placeholder}
        type={type}
        style={styles}
        />
    )
  }
}

export default TextField
