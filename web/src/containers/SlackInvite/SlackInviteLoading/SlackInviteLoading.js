import React, { Component } from 'react'

class SlackInviteLoading extends Component {
  componentDidMount() {
    this.intervalID = setInterval(this.props.interval, 1000)
  }

  componentWillUnmount() {
    clearInterval(this.intervalID)
  }

  render() {
    return (
      <p>Loading content...</p>
    )
  }
}

export default SlackInviteLoading
