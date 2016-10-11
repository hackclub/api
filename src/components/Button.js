import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../colors'

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
  }
}

class Button extends Component {
  render() {
    const type = this.props.type
    const disabled = this.props.disabled

    let button = null

    switch(type) {
    case 'form':
      button =
        <button type="submit"
                style={[
                  styles.base,
                  styles.form,
                  this.props.style
                ]}
                disabled={disabled}>
          {this.props.children}
        </button>
        break
    case 'link':
      button =
        <a href={this.props.href}
           style={[
             styles.base,
             styles.link,
             this.props.style
           ]}>
          {this.props.children}
        </a>
        break
    default:
      throw 'Invalid type'
    }

    return button
  }
}

export default Radium(Button)
