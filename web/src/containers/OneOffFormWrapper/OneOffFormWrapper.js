import React, { Component } from 'react'
import Radium from 'radium'
import pattern from '../../styles/pattern.png'

const styles = {
  height: '100%',
  minWidth: '100%',
  backgroundImage: `url(${pattern})`,
  backgroundSize: '450px'
}

class OneOffFormWrapper extends Component {
  render() {
    return (
      <div style={styles}>
        {this.props.children}
      </div>
    )
  }
}

export default Radium(OneOffFormWrapper)
