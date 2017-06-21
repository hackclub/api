import React, { Component } from 'react'
import {
  HorizontalRule,
  NavBar,
} from '../../components'
import { mediaQueries } from '../../styles/common'

import StepsHeader from './StepsHeader/StepsHeader'
import StepsDescription from './StepsDescription/StepsDescription'
import StartForm from './StartForm/StartForm'

const styles = {
  hr: {
    width: '80%',
    height: '4px',
    marginTop: '-2px',
    marginLeft: 'auto',
    marginRight: 'auto',
    marginBottom: 0,
    [mediaQueries.mediumUp]: {
      width: '70%',
      height: '5px',
      marginTop: '-2.5px'
    }
  }
}

class Start extends Component {
  render() {
    return (
      <div>
        <NavBar />
        <StepsHeader />
        <HorizontalRule style={styles.hr} />
        <StepsDescription />
        <StartForm />
      </div>
    )
  }
}

export default Start
