import React, { Component } from 'react'
import Radium from 'radium'

const style = {
  width: '1em',
  height: '1em',
  display: 'inline-block',
  backgroundSize: 'contain',
  color: 'transparent',
  overflow: 'hidden',
  textAlign: 'left',
  verticalAlign: 'middle',
  whiteSpace: 'nowrap',
  textIndent: '100%'
}

class Emoji extends Component {
  backgroundStyle = {
    backgroundImage: `url(${require(`./images/${this.props.children}.png`)})`
  }

  render() {
    return (
      <span style={[style,this.props.style,this.backgroundStyle]}>
        :{this.props.children}:
      </span>
    )
  }
}

export default Radium(Emoji)
