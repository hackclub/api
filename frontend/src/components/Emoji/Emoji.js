import React, { Component } from 'react'
import Radium from 'radium'

import spritesheet from './spritesheet.png'
import './emoji.css'

const styles = {
  width: '1.5em',
  height: '1.5em',
  marginTop: '-0.25em',
  display: 'inline-block',
  color: 'transparent',
  overflow: 'hidden',
  textAlign: 'left',
  verticalAlign: 'middle',
  whiteSpace: 'nowrap',
  textIndent: '100%'
}

class Emoji extends Component {
  render() {
    const emojiName = this.props.type.replace(/ /g, '_')

    const backgroundStyle = {
      backgroundImage: `url(${spritesheet})`,
      width: '72px',
      height: '72px'
    }

    return (
      <span className={`emoji-${emojiName}`} style={[styles,backgroundStyle,this.props.style]}>
        {`:${emojiName}:`}
      </span>
    )
  }
}

export default Radium(Emoji)
