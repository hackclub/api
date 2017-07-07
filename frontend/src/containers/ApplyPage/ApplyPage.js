import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as applyActions from '../../redux/modules/apply'
import { SubmissionError } from 'redux-form'

import {
  Heading,
  NavBar,
  Container,
  Link,
  ApplicationForm,
  Card
} from '../../components'

import { mediaQueries } from '../../styles/common'

const styles = {
  wrapper: {
    marginLeft: 'auto',
    marginRight: 'auto',
    textAlign: 'center',
    paddingTop: '25px',
    paddingBottom: '25px',
    [mediaQueries.mediumUp]: {
      backgroundSize: '450px',
      paddingTop: '50px',
      paddingBottom: '60px'
    }
  },
  hr: {
    width: '80%',
    height: '4px',
    marginTop: '-2px',
    marginLeft: 'auto',
    marginRight: 'auto',
    marginBottom: 0,
    [mediaQueries.mediumUp]: {
      width: '70%',
      height: '5px',
      marginTop: '-2.5px'
    }
  },
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '1000px'
  }
}

const headingStyles = {
  fontWeight: 'bolder',
  fontSize: '26px',
  [mediaQueries.mediumUp]: {
    fontSize: '36px'
  }
}

class ApplyHeading extends Component {
  render() {
    return (
      <div>
        <Heading style={headingStyles}>Apply to Start a Hack Club</Heading>
      </div>
    )
  }
}

class ApplyInfo extends Component {
  render() {
    return (
      <div>
        <p>We're accepting applications all the time. It's great if your responses to these questions are over 3 sentences long, but make sure you don't write an essay!</p>

        <br />

        <p>Check out our <Link href="/example_applications">example applications</Link> if you want some help!</p>
      </div>
    )
  }
}

class Apply extends Component {
  static propTypes = {
    status: PropTypes.string
  }

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  render() {
    return (
      <div>
        <Helmet title="Apply" />

        <NavBar />
        <Container style={[styles.wrapper]}>
          <ApplyHeading />

          <ApplyInfo />
        </Container>

        <Card style={[styles.card]}>
          <ApplicationForm onSubmit={values => this.handleSubmit(values)} status={status} />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.apply.status
})

export default connect(
  mapStateToProps,
  {...applyActions}
)(Radium(Apply))
