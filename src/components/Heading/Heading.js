import React, { Component } from 'react'
import Radium from 'radium'

const styles = {
  fontSize: '28px',
  lineHeight: '32px',
  fontWeight: 'bold',
  marginBottom: '15px',
  cursor: 'text'
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
