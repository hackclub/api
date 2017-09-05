import React, { Component } from 'react'
import Radium from 'radium'
import {
  Container,
  Heading,
} from '../../../components'
import { mediaQueries } from '../../../styles/common'

import Step from './Step'
import Arrow from './Arrow'

import pattern from '../../../styles/pattern.png'

import chatBubbles from './chat_bubbles.svg'
import communityOfHackers from './community_of_hackers.svg'
import pencilAndPaper from './pencil_and_paper.svg'

const styles = {
  wrapper: {
    marginLeft: 'auto',
    marginRight: 'auto',
    textAlign: 'center',
    backgroundImage: `url(${pattern})`,
    backgroundSize: '250px',
    paddingTop: '25px',
    paddingBottom: '25px',
    [mediaQueries.mediumUp]: {
      backgroundSize: '450px',
      paddingTop: '50px',
      paddingBottom: '60px'
    }
  },
  heading: {
    fontWeight: 'bolder',
    fontSize: '26px',
    [mediaQueries.mediumUp]: {
      fontSize: '36px'
    }
  },
  steps: {
    marginTop: '25px',
    display: 'flex',
    alignItems: 'flex-end',
    justifyContent: 'center',
    [mediaQueries.mediumUp]: {
      marginTop: '50px'
    }
  },
  arrow: {
    alignSelf: 'center',
    marginLeft: '10px',
    marginRight: '10px',
    marginTop: '-20px',
    [mediaQueries.mediumUp]: {
      marginLeft: '25px',
      marginRight: '25px',
      marginTop: 0
    },
    [mediaQueries.largeUp]: {
      marginLeft: '50px',
      marginRight: '50px',
    }
  }
}

class StepsHeader extends Component {
  render() {
    return (
      <div style={[styles.wrapper,this.props.style]}>
        <Container>
          <Heading style={styles.heading}>Start a Hack Club</Heading>
          <div style={styles.steps}>
            <Step icon={pencilAndPaper}
                  iconAlt="Pencil and paper"
                  text="Submit an application" />
            <Arrow style={styles.arrow} />
            <Step icon={chatBubbles}
                  iconAlt="Chat bubbles"
                  text="Training call" />
            <Arrow style={styles.arrow} />
            <Step icon={communityOfHackers}
                  iconAlt="Community of hackers"
                  text="Lead your club" />
          </div>
        </Container>
      </div>
    )
  }
}

export default Radium(StepsHeader)
