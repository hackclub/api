import React, { Component } from 'react'
import {
  Container,
  Heading,
  Text,
} from '../../../components'
import StepDescription from './StepDescription'
import colors from '../../../styles/colors'

import michaelReachingOut from './michael_reaching_out.svg'

const styles = {
  heading: {
    fontWeight: 'thin',
    fontSize: '34px',
    marginTop: '60px',
    marginBottom: '40px'
  },
  descLayout: {
    display: 'flex',
    justifyContent: 'space-between',
    overflow: 'hidden'
  },
  description: {
    width: '60%',
    fontSize: '24px'
  },
  leadingText: {
    fontSize: '20px'
  },
  person: {
    marginRight: '20px',
    marginBottom: '-25px'
  }
}

class StepsDescription extends Component {
  render() {
    return (
      <Container>
        <Heading style={styles.heading}>You and your team will do great things with Hack Club</Heading>
        <div style={styles.descLayout}>
          <div style={styles.description}>
            <Text style={styles.leadingText}>We make it effortless to get your club off the ground.</Text>
            <StepDescription
               color={colors.primary}
               title="Curriculum"
               description="Plan your meetings faster with our pre-built curriculum, making it as easy as ever to have a great meeting every time."
               />
            <StepDescription
               color={colors.offBrandEmphasis}
               title="Structure"
               description="With Hack Club's pre-planned structure, getting your club off the ground is not only turn-key, but flexible."
               />
            <StepDescription
               color={colors.offBrandSecondaryEmphasis}
               title="Marketing"
               description="We'll make sure that you'll sell your club as a world-class experience every time. Stickers, other marketing materials, etc."
               />
          </div>
          <img src={michaelReachingOut} alt="Person offering help" style={styles.person} />
        </div>
      </Container>
    )
  }
}

export default StepsDescription
