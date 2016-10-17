import React from 'react'
import Field from '../Field/Field'
import colors from '../../colors'

const styles = {
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

class TextAreaField extends Field {
  renderInput() {
    const { input, label } = this.props

    return (
      <textarea {...input} style={styles} placeholder={label} />
    )
  }
}

export default TextAreaField
