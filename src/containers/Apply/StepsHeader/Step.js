import React, { Component } from 'react'
import Radium from 'radium'
import {
  Text,
} from '../../../components'
import colors from '../../../styles/colors'

const styles = {
  base: {
    display: 'inline-block'
  },
  icon: {
    maxHeight: '130px',
    minWidth: '60px',
    marginBottom: '20px'
  },
  text: {
    fontWeight: 'bold',
    fontSize: '28px',
    color: colors.offBlack
  }
}

class Step extends Component {
  render() {
    const { icon, iconAlt, text } = this.props

    return (
      <div style={styles.base}>
        <img style={styles.icon} src={icon} alt={iconAlt} />
        <Text style={styles.text}>{text}</Text>
      </div>
    )
  }
}

export default Radium(Step)
