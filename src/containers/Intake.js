import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import { connect } from 'react-redux'
import { createLeader } from '../actions'
import IntakeForm from './IntakeForm'
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
    lineHeight: '20px'
  },
  header: {
    textAlign: 'center',
    backgroundColor: '#e42d40',
    height: '150px',
    padding: '20px',
    color: 'white'
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
          <h1 style={styles.partyPopper}>🎉</h1>
          <h2>Welcome to Hack Club! All fields are required.</h2>
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
