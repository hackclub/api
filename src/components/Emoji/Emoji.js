import React, { Component } from 'react'
import Radium from 'radium'

const style = {
  width: '1.5em',
  height: '1.5em',
  marginTop: '-0.25em',
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
