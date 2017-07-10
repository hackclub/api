import React, { Component } from 'react'

import { Heading } from '../../../components'
import { mediaQueries } from '../../../styles/common'

const styles = {
  fontWeight: 'bolder',
  fontSize: '26px',
  [mediaQueries.mediumUp]: {
    fontSize: '36px'
  }
}

class ApplyHeading extends Component {
  render() {
    return (
      <div>
        <Heading style={styles}>Apply to Start a Hack Club</Heading>
      </div>
    )
  }
}

export default ApplyHeading
