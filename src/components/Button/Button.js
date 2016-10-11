import React, { Component } from 'react'
import Radium from 'radium'
import { ThreeBounce } from 'better-react-spinkit'
import colors from '../../colors'

const styles = {
  base: {
    backgroundColor: colors.primary,

    fontFamily: 'inherit',
    fontSize: '20px',
    fontWeight: 'bold',
    color: colors.bg,

    width: '100%',
    boxSizing: 'border-box',
    display: 'inline-block',
    padding: '15px',

    border: 'none',
    borderRadius: '3px',

    cursor: 'pointer'
  },
  form: {
    ':disabled': {
      cursor: 'default'
    }
  },
  link: {
    textAlign: 'center',
    textDecoration: 'none'
  },
  disabled: {
    backgroundColor: colors.fadedPrimary
  }
}

class Button extends Component {
  render() {
    const type = this.props.type
    const disabled = this.props.disabled
    const loading = this.props.loading

    let button = null
    let buttonContents = loading ?
                           <ThreeBounce size={15} color={colors.bg} /> :
                           this.props.children

    switch(type) {
    case 'form':
      button =
        <button type="submit"
                style={[
                  styles.base,
                  styles.form,
                  disabled ? styles.disabled : null,
                  this.props.style
                ]}
                disabled={disabled}>
          {buttonContents}
        </button>
        break
    case 'link':
      button =
        <a href={this.props.href}
           style={[
             styles.base,
             styles.link,
             disabled ? styles.disabled : null,
             this.props.style
           ]}>
          {buttonContents}
        </a>
        break
    default:
      throw new Error('Invalid type')
    }

    return button
  }
}

export default Radium(Button)
