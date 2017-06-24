import React, { Component } from 'react'
import Radium from 'radium'
import { NotFound } from '../../containers'
import Markdown from 'react-markdown'

class Workshop extends Component {
  render() {
    try {
      var fileContents = require(`./data/${this.props.path}`)
    } catch (e) {
      try {
        fileContents = require(`./data/${this.props.path}`.replace(/\/$/, '') + '/README.md')
      } catch (e) {
        // TODO: Respond with a proper 404
        return(
          <NotFound/>
        )
      }
    }

    return(
      <div>
        <Markdown source={fileContents} />
      </div>
    )
  }
}

export default Radium(Workshop)
