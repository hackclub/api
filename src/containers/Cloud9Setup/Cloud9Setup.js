import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import { SubmissionError } from 'redux-form'
import { Card, Cloud9SetupForm, Emoji, Header, Heading, Text } from '../../components'
import * as cloud9SetupActions from '../../redux/modules/cloud9Setup'

const styles = {
  cloud: {
    fontSize: '36px',
    lineHeight: '75%'
  },
  instructions: {
    fontSize: '22px',
    marginTop: '20px'
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

    return submit(values.email)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  render() {
    const { status } = this.props

    const emoji = status === "success" ?
                  "sun_behind_cloud" :
                  "cloud"

    return (
      <div>
        <Helmet title="Cloud9 Setup" />
        <Header>
          <Heading style={styles.cloud}>
            <Emoji type={emoji} />
          </Heading>
          <Heading>Welcome to Hack Club! Let's get you on Cloud9.</Heading>
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

export default connect(
  mapStateToProps,
  {...cloud9SetupActions}
)(Radium(Cloud9Setup))
