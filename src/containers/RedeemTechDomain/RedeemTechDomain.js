import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import { SubmissionError } from 'redux-form'
import {
  Card,
  Container,
  Header,
  Heading,
  RedeemTechDomainForm,
  Text,
} from '../../components'
import * as techDomainRedemptionActions from '../../redux/modules/techDomainRedemption'

import colors from '../../styles/colors'

const styles = {
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

class RedeemTechDomain extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values.name, values.email, values.requested_domain, values.secret_code)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  render() {
    const { status } = this.props

    console.log(status);

    return (
      <div>
        <Helmet title="Get a Free .TECH Domain" />
        <Header>
          <Container>
            <Heading style={styles.heading}>Get a free .TECH domain!</Heading>
            <Text style={styles.instructions}>
              We've partnered with the folks that own all of the .tech domains
              to get every Hack Club member a free domain.
            </Text>

            <Text style={styles.instructions}>
              Fill out the form below to submit your request and the .tech team
              will get you set up (they generally respond to requests within the
              day).
            </Text>
          </Container>
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
