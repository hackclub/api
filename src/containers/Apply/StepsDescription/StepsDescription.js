import React, { Component } from 'react'
import {
  Container,
  Heading,
  Text,
} from '../../../components'
import StepDescription from './StepDescription'
import colors from '../../../styles/colors'
import { mediaQueries } from '../../../styles/common'

import michaelReachingOut from './michael_reaching_out.svg'

const styles = {
  wrapper: {
    marginTop: '25px',
    marginBottom: '30px',
    [mediaQueries.mediumUp]: {
      marginTop: '40px',
      marginBottom: 'inherit'
    }
  },
  heading: {
    fontWeight: 'thin',
    fontSize: '26px',
    marginBottom: '20px',
    textAlign: 'center',
    [mediaQueries.mediumUp]: {
      fontSize: '34px',
      textAlign: 'inherit'
    }
  },
  descLayout: {
    [mediaQueries.mediumUp]: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'flex-end',
      overflow: 'hidden'
    }
  },
  description: {
    marginBottom: '20px',
    [mediaQueries.mediumUp]: {
      width: '60%'
    }
  },
  leadingText: {
    display: 'none',
    [mediaQueries.mediumUp]: {
      display: 'inherit',
      fontSize: '20px'
    }
  },
  person: {
    display: 'none',
    [mediaQueries.mediumUp]: {
      display: 'inherit',
      minWidth: '185px',
      width: '20%',
      maxHeight: '100%',
      marginRight: '5%',
      marginBottom: '-1%'
    }
  }
}

class StepsDescription extends Component {
  render() {
    return (
      <Container style={styles.wrapper}>
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
               description="With Hack Club's battle-tested club structure, you're sure to get your club off on the right foot."
               />
            <StepDescription
               color={colors.offBrandSecondaryEmphasis}
               title="Community"
               description="By starting a Hack Club, you become a part of something much larger than your school – the worldwide community of young hackers."
               />
          </div>
          <img src={michaelReachingOut} alt="Person offering help" style={styles.person} />
        </div>
      </Container>
    )
  }
}

export default StepsDescription
