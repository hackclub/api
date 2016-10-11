import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import { connect } from 'react-redux'
import { createLeader } from '../actions'

import Header from '../components/Header'
import IntakeForm from './IntakeForm'
import colors from '../colors'
import logo from './logo.svg'

const styles = {
  logo: {
    height: '40px',
    position: 'absolute',
    top: '15px',
    right: '12.5px'
  },
  partyPopper: {
    fontSize: '60px',
    marginTop: '15px',
    marginBottom: '25px'
  },
  headerText: {
    fontSize: '22px',
    color: colors.bg
  },
  header: {
    textAlign: 'center',
    backgroundColor: colors.primary,
    padding: '20px'
  },
  intro: {
    fontSize: 'large'
  }
}

class Intake extends Component {
  constructor(props) {
    super(props)
    this.handleIntakeSubmit = this.handleIntakeSubmit.bind(this)
  }

  handleIntakeSubmit(formValues) {
    const { dispatch } = this.props
    dispatch(createLeader(formValues))
  }

  render() {
    const { isSubmitting, didSucceed, submissionError } = this.props
    return (
      <div>
        <div style={styles.header}>
          <a href="https://hackclub.com" target="_blank">
            <img src={logo} style={styles.logo} alt="logo" />
          </a>
          <Header style={styles.partyPopper}>🎉</Header>
          <Header style={styles.headerText}>
            Welcome to Hack Club! All fields are required.
          </Header>
        </div>
        <IntakeForm
          onSubmit={this.handleIntakeSubmit}
          isSubmitting={isSubmitting}
          submissionError={submissionError}
          didSucceed={didSucceed} />
      </div>
    )
  }
}

Intake.propTypes = {
  isSubmitting: PropTypes.bool.isRequired,
  submissionError: PropTypes.string,
  didSucceed: PropTypes.bool,
  dispatch: PropTypes.func.isRequired
}

function mapStateToProps(state) {
  const { isSubmitting, submissionError, didSucceed } = state.leader
  return {
    isSubmitting,
    submissionError,
    didSucceed
  }
}

export default connect(mapStateToProps)(Radium(Intake))
