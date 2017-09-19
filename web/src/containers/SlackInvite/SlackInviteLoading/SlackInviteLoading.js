import React, { Component } from 'react'
import { Card, LoadingSpinner } from 'components'

const stages = ['invited', 'invite_received', 'signed_up', 'configured_client', 'changed_email']

const styles = {
  card: {
    marginTop: '20px',
    marginLeft: 'auto',
    marginRight: 'auto',
  },
  loadingSpinner: {
    marginTop: '3em',
    marginBottom: '1em',
  }
}

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
      <Card style={styles.card}>
        <LoadingSpinner style={styles.loadingSpinner} />
        <p>Working on step {stageNumber} / {stages.length}...</p>
      </Card>
    )
  }
}

export default SlackInviteLoading
