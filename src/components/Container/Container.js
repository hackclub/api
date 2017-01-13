import React, { Component } from 'react'
import Radium from 'radium'

const styles = {
  marginLeft: 'auto',
  marginRight: 'auto',
  width: '900px'
}

class Container extends Component {
  render() {
    return (
      <div style={[styles,this.props.style]}>
        {this.props.children}
      </div>
    )
  }
}

export default Radium(Container)
