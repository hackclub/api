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
               description="Plan your meetings faster with our pre-built curriculum. Your members will thank you for introducing them to coding through creating apps, websites, and video games."
               />
            <StepDescription
               color={colors.offBrandEmphasis}
               title="Structure"
               description="Club meetings resemble hackathons, meaning that every member will work from their own computer, building their own individual projects. Your club members will leave excited about what they've built after every meeting."
               />
            <StepDescription
               color={colors.offBrandSecondaryEmphasis}
               title="Marketing"
               description="We'll help you spread the word about your club at your school by providing you with stickers and posters, as well as any other help you might need."
               />
          </div>
          <img src={michaelReachingOut} alt="Person offering help" style={styles.person} />
        </div>
      </Container>
    )
  }
}

export default StepsDescription
