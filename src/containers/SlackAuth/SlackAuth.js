import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import {
  Card
} from '../../components'
import LoginPrompt from './LoginPrompt'
import OauthSuccess from './OauthSuccess'
import OauthFailure from './OauthFailure'

const styles = {
  wrapper: {
    width: '100%',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  },
  card: {
    marginLeft: 'auto',
    marginRight: 'auto'
  }
}

class SlackAuth extends Component {
  componentToRender() {
    const { code, error } = this.props.location.query

    if (code && !error) {
      return <OauthSuccess code={code} />
    } else if (error && !code) {
      return <OauthFailure error={error} />
    } else {
      return <LoginPrompt />
    }
  }

  render() {
    const component = this.componentToRender()

    return (
      <div style={[styles.wrapper,this.props.style]}>
        <Helmet title="Slack Auth" />
        <Card style={styles.card}>
          {component}
        </Card>
      </div>
    )
  }
}

export default Radium(SlackAuth)
