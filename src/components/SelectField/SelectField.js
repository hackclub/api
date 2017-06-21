import React from 'react'
import Field from '../Field/Field'
import colors from '../../styles/colors'

const styles = {
  fontFamily: 'inherit',
  fontSize: '16px',
  color: colors.userInput,

  width: '100%',
  boxSizing: 'border-box',
  display: 'block',

  height: '35px',

  borderRadius: '3px',
  border: `1px solid ${colors.outline}`,

  background: 'none'
}

class SelectField extends Field {
  renderInput() {
    const { input } = this.props

    return (
      <select {...input} style={styles}>
        {this.props.children}
      </select>
    )
  }
}

export default SelectField
