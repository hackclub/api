import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../styles/colors'

const styles = {
  fontSize: '28px',
  lineHeight: '125%',
  fontWeight: '600',
  marginBottom: '15px',
  cursor: 'text',
  color: colors.text
}

class Heading extends Component {
  render() {
    return (
      <h1 style={[styles,this.props.style]}>
        {this.props.children}
      </h1>
    )
  }
}

export default Radium(Heading)
