import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../styles/common'

const styles = {
  marginLeft: 'auto',
  marginRight: 'auto',
  width: '90%',
  [mediaQueries.mediumUp]: {
    width: '900px'
  }
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
