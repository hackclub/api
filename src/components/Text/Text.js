import React, { Component } from 'react'
import Radium from 'radium'

const styles = {
  marginBottom: '5px'
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
