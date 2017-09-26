import React, { Component } from 'react'
import Radium from 'radium'
import config from 'config'
import InviteInfo from './InviteInfo/InviteInfo'
import InviteLoading from './InviteLoading/InviteLoading'
import { NotFound } from 'components'

const inviteStates = ['invited', 'invite_received', 'signed_up', 'configured_client', 'changed_email']

class SlackInviteInstructions extends Component {
  constructor(props) {
    super(props)

    this.pollForUpdate = this.pollForUpdate.bind(this)

    this.name = props.params.name
    this.id = props.params.id
  }

  pollForUpdate() {
    const apiUrl = `${config.apiBaseUrl}/v1/slack_invitation/invite/${this.id}`

    fetch(apiUrl)
      .then(response => {
        return response.json()
      })
      .then(json => {
        const state = {
          inviteState: json.state,
          tempEmail: json.temp_email,
        }

        if (json.state === 'changed_email') {
          this.ensurePollingStops()
        }

        this.setState(state)
      })
      .catch(err => console.error(err))
  }

  ensurePollingStops() {
    const { polling } = this.state

    if (polling) {
      this.setState({
        polling: false
      })
      clearInterval(this.intervalID)
    }
  }

  componentDidMount() {
    this.intervalID = setInterval(this.pollForUpdate, 1000)
    this.setState({
      polling: true
    })
  }

  componentWillUnmount() {
    this.ensurePollingStops()
  }

  render() {
    const { tempEmail, inviteState, notFound } = this.state

    if (notFound) {
      return <NotFound />
    } else if (inviteState === 'changed_email') {
      return <InviteInfo tempEmail={tempEmail} />
    } else {
      return <InviteLoading inviteState={inviteState} inviteStates={inviteStates} tempEmail={tempEmail} />
    }
  }
}

export default Radium(SlackInviteInstructions)
