import React, { Component } from 'react'
import Radium from 'radium'
import {
  Text,
} from '../../../components'
import colors from '../../../styles/colors'
import { mediaQueries } from '../../../styles/common'

const iconSmallWidth = 85
const iconMediumWidth = 115
const iconLargeWidth = 125
const iconMaxHeightRatio = 0.85

const styles = {
  base: {
    display: 'inline-block',
    width: '150px',
  },
  icon: {
    width: `${iconSmallWidth}px`,
    maxHeight: `${iconSmallWidth*iconMaxHeightRatio}px`,
    marginBottom: '5px',
    [mediaQueries.mediumUp]: {
      width: `${iconMediumWidth}px`,
      maxHeight: `${iconMediumWidth*iconMaxHeightRatio}px`,
      marginBottom: '20px'
    },
    [mediaQueries.largeUp]: {
      width: `${iconLargeWidth}px`,
      maxHeight: `${iconLargeWidth*iconMaxHeightRatio}px`,
    }
  },
  text: {
    fontWeight: 'bold',
    color: colors.offBlack,
    fontSize: '18px',
    [mediaQueries.mediumUp]: {
      fontSize: '28px',
    }
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
