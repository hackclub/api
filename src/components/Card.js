import React, { Component } from 'react'
import Radium from 'radium'

const styles = {
  backgroundColor: '#ffffff',
  width: '350px',
  padding: '17.5px',
  border: '1px solid #cccccc',
  boxShadow: '0px 1px 50px -15px #888888',
  borderRadius: '5px'
}

class Card extends Component {
  render() {
    return (
      <div style={styles}>
        {this.props.children}
      </div>
    )
  }
}

export default Radium(Card)
