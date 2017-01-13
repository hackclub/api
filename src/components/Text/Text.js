import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../styles/colors'

const styles = {
  marginBottom: '10px',
  fontSize: '16px',
  color: colors.text
}

class Text extends Component {
  render() {
    return (
      <p style={[styles,this.props.style]}>
        {this.props.children}
      </p>
    )
  }
}

export default Radium(Text)
