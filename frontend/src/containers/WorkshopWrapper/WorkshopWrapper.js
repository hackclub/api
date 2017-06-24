import React, { Component } from 'react'
import Radium from 'radium'
import { Workshop } from '../../components'

class WorkshopWrapper extends Component {
  render() {
    return (
      <div>
        <Workshop path={this.props.params.splat} />
      </div>
    )
  }
}

export default Radium(WorkshopWrapper)
