import React, { Component } from 'react'
import { LoadingSpinner, Text } from 'components'

const styles = {
  height: '100%'
}

class InviteLoading extends Component {
  loadingSteps() {
    const { inviteStates, inviteState } = this.props

    if (inviteState) {
      return (
        <Text>
          Working on step {inviteStates.indexOf(inviteState) + 1} /{' '}
          {inviteStates.length}
        </Text>
      )
    }
  }

  tempEmail() {
    const { tempEmail } = this.props

    if (tempEmail) {
      return <Text>Your temporary sign up email will be {tempEmail}</Text>
    }
  }

  render() {
    return (
      <div style={styles}>
        <LoadingSpinner>
          {this.loadingSteps()}
          {this.tempEmail()}
        </LoadingSpinner>
      </div>
    )
  }
}

export default InviteLoading
