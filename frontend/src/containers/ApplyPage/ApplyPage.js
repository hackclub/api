import React, { Component} from 'react'
import {
  HorizontalRule,
  NavBar,
} from '../../components'
import { mediaQueries } from '../../styles/common'

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

class Apply extends Component {
  render() {
    return (
      <div>
        <NavBar />
        <h1>Hello</h1>
      </div>
    )
  }
}

export default Apply
