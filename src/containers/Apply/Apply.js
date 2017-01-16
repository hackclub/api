import React, { Component } from 'react'
import {
  HorizontalRule,
  NavBar,
} from '../../components'

import StepsHeader from './StepsHeader/StepsHeader'
import StepsDescription from './StepsDescription/StepsDescription'
import ApplyForm from './ApplyForm/ApplyForm'

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
        <StepsDescription />
        <ApplyForm />
      </div>
    )
  }
}

export default Apply
