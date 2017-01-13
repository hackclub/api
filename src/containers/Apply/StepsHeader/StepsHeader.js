import React, { Component } from 'react'
import Radium from 'radium'
import {
  Container,
  Heading,
} from '../../../components'
import colors from '../../../styles/colors'

import Step from './Step'
import Arrow from './Arrow'

import pattern from '../../../styles/pattern.png'

import pencilAndPaper from './pencil_and_paper.svg'
import chatBubbles from './chat_bubbles.svg'
import numberedPaper from './numbered_paper.svg'

const styles = {
  wrapper: {
    marginLeft: 'auto',
    marginRight: 'auto',
    textAlign: 'center',
    backgroundImage: `url(${pattern})`,
    backgroundSize: '450px',
    paddingTop: '50px',
    paddingBottom: '75px'
  },
  heading: {
    fontWeight: 'bolder',
    fontSize: '36px'
  },
  steps: {
    marginTop: '50px',
    display: 'flex',
    alignItems: 'flex-end',
    justifyContent: 'center'
  },
  arrow: {
    marginLeft: '50px',
    marginRight: '50px',
    alignSelf: 'center'
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
                  text="Apply" />
            <Arrow style={styles.arrow} />
            <Step icon={chatBubbles}
                  iconAlt="Chat bubbles"
                  text="Interview" />
            <Arrow style={styles.arrow} />
            <Step icon={numberedPaper}
                  iconAlt="Numbered piece of paper"
                  text="Training" />
          </div>
        </Container>
      </div>
    )
  }
}

export default Radium(StepsHeader)
