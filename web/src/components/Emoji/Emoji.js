import React from 'react'
import Radium from 'radium'

const styles = {
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

const Emoji = props => {
  const { type } = props
  const backgroundStyle = {
    backgroundImage: `url('/emoji/${type}.png')`
  }

  return (
    <span style={[styles, backgroundStyle, props.style]}>{`:${type}:`}</span>
  )
}

export default Radium(Emoji)
