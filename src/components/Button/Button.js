import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import { ThreeBounce } from 'better-react-spinkit'
import colors from '../../styles/colors'

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

    transition: 'all .5s',

    cursor: 'pointer'
  },
  form: {
    outline: 'none',

    ':disabled': {
      cursor: 'default'
    }
  },
  link: {
    textAlign: 'center',
    textDecoration: 'none'
  },
  state: {
    disabled: {
      backgroundColor: colors.fadedPrimary
    },
    error: {
      backgroundColor: colors.warning
    },
    success: {
      backgroundColor: colors.success
    }
  }
}

class Button extends Component {
  static propTypes = {
    type: PropTypes.string.isRequired,
    state: PropTypes.string, // Can be disabled, error, loading, or success
    href: PropTypes.string,
    style: PropTypes.object
  }

  render() {
    const type = this.props.type
    const state = this.props.state
    const givenStyle = this.props.style
    const href = this.props.href

    let button = null
    let buttonContents = state === "loading" ?
                           <ThreeBounce size={15} color={colors.bg} /> :
                           this.props.children

    switch(type) {
    case 'form':
      button =
        <button type="submit"
                style={[
                  styles.base,
                  styles.form,
                  styles.state[state],
                  givenStyle
                ]}
                disabled={state === "disabled"}>
          {buttonContents}
        </button>
        break
    case 'link':
      button =
        <a href={href}
           style={[
             styles.base,
             styles.link,
             styles.state[state],
             givenStyle
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
