import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { Card, Cloud9SetupForm, Emoji, Header, Heading, Text } from 'components'
import colors from 'styles/colors'

import { connect } from 'react-redux'
import * as cloud9SetupActions from 'redux/modules/cloud9Setup'
import { SubmissionError } from 'redux-form'

const styles = {
  cloud: {
    fontSize: '36px',
    lineHeight: '75%'
  },
  heading: {
    color: colors.bg
  },
  instructions: {
    fontSize: '22px',
    marginTop: '20px',
    color: colors.bg
  },
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '40px',
    marginBottom: '40px'
  }
}

class Cloud9Setup extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.email).catch(error => {
      throw new SubmissionError(error.errors)
    })
  }

  render() {
    const { status } = this.props

    const emoji = status === 'success' ? 'sun_behind_cloud' : 'cloud'

    return (
      <div>
        <Helmet title="Cloud9 Setup" />
        <Header>
          <Heading style={styles.cloud}>
            <Emoji type={emoji} />
          </Heading>
          <Heading style={styles.heading}>
            Welcome to Hack Club! Let's get you on Cloud9.
          </Heading>
          <Text style={styles.instructions}>
            Just fill out the form below and check your email.
          </Text>
        </Header>
        <Card style={styles.card}>
          <Cloud9SetupForm
            status={status}
            onSubmit={values => this.handleSubmit(values)}
          />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.cloud9Setup.status
})

export default connect(mapStateToProps, { ...cloud9SetupActions })(
  Radium(Cloud9Setup)
)
