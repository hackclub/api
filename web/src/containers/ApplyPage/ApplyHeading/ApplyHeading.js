import React from 'react'

import { Heading } from 'components'
import { mediaQueries } from 'styles/common'

const styles = {
  fontWeight: 'bolder',
  fontSize: '26px',
  marginBottom: 0,
  [mediaQueries.mediumUp]: {
    display: 'none'
  }
}

const ApplyHeading = () => {
  return (
    <div>
      <Heading style={styles}>Apply to Start a Hack Club</Heading>
    </div>
  )
}

export default ApplyHeading
