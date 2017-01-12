import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import { SubmissionError } from 'redux-form'
import { Anchor, Card, Emoji, Header, Heading, Link, RedeemTechDomainForm, Text } from '../../components'
import * as techDomainRedemptionActions from '../../redux/modules/techDomainRedemption'

const styles = {
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

class RedeemTechDomain extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.name, values.email, values.domain, values.secret)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  render() {
    const { status } = this.props

    console.log(status);

    return (
      <div>
        <Helmet title="Redeem your .TECH domain!" />
        <Header>
          <Heading>Get a free .TECH domain!</Heading>
          <Text style={styles.instructions}>
            Hack Club has partnered with .tech to get every Hack Club member a free .tech domain.
          </Text>

          <Text style={styles.instructions}>
            Just fill out the form below to submit your request and the <a href="http://get.tech">.tech</a> team will get you set up (they generally respond to requests within the day). Shoot an email to <a href="mailto:zach@hackclub.com">zach@hackclub.com</a> if you run into any trouble.
          </Text>
        </Header>

        <Card style={styles.card}>
          <RedeemTechDomainForm
            onSubmit={values => this.handleSubmit(values)}
            status={status}
            />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
    status: state.techDomainRedemption.status
})

export default connect(
  mapStateToProps,
  {...techDomainRedemptionActions}
)(Radium(RedeemTechDomain))
