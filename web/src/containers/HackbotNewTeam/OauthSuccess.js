import React, { Component } from 'react'
import { connect } from 'react-redux'
import * as hackbotActions from 'redux/modules/hackbot'
import { Link, Text } from 'components'

const { STATUS_SUCCESS, STATUS_ERROR } = hackbotActions

class OauthSuccess extends Component {
  componentDidMount() {
    const { auth, code } = this.props

    auth(code)
  }

  render() {
    const { status } = this.props

    switch (status) {
      case STATUS_SUCCESS:
        return <div>Success! You're all set.</div>
      case STATUS_ERROR:
        return (
          <div>
            <Text>Oh snap, there was some sort of error on our end.</Text>
            <Link to="/hackbot/teams/new">Try again?</Link>
          </div>
        )
      default:
        return <div>Logging you in...</div>
    }
  }
}

const mapStateToProps = state => ({
  status: state.hackbot.auth.status
})

export default connect(mapStateToProps, { ...hackbotActions })(OauthSuccess)
