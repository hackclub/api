import React, { Component } from 'react'
import {
  HorizontalRule,
  NavBar,
} from '../../components'

import StepsHeader from './StepsHeader/StepsHeader'

const styles = {
  hr: {
    margin: 0,
    width: '70%',
    height: '5px',
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '-2.5px'
  }
}

class Apply extends Component {
  render() {
    return (
      <div>
        <NavBar />
        <StepsHeader />
        <HorizontalRule style={styles.hr} />
      </div>
    )
  }
}

export default Apply
