import React, { Component } from 'react'

const stages = ['invited', 'invite_received', 'signed_up', 'configured_client', 'changed_email']

class SlackInviteLoading extends Component {
  componentDidMount() {
    this.intervalID = setInterval(this.props.poll, 1000)
  }

  componentWillUnmount() {
    clearInterval(this.intervalID)
  }

  render() {
    const { inviteState } = this.props
    const stageNumber = stages.indexOf(inviteState) + 1

    return (
      <p>
        Loading content... Working on step {stageNumber} / {stages.length}...
      </p>
    )
  }
}

export default SlackInviteLoading
