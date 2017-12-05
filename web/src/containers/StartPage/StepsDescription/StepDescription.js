import React, { Component } from 'react'
import { Heading, Text } from 'components'

class StepDescription extends Component {
  getStyles() {
    const { color } = this.props

    return {
      wrapper: {
        marginTop: '30px'
      },
      heading: {
        color: color,
        textTransform: 'uppercase',
        fontSize: '20px',
        fontWeight: '600',
        marginBottom: '10px',
        letterSpacing: '1px'
      },
      text: {
        fontSize: '18px',
        lineHeight: '24px'
      }
    }
  }

  render() {
    const { title, description } = this.props

    const styles = this.getStyles()

    return (
      <div style={styles.wrapper}>
        <Heading style={styles.heading}>{title}</Heading>
        <Text style={styles.text}>{description}</Text>
      </div>
    )
  }
}

export default StepDescription
