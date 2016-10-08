import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { createLeader } from '../actions'
import IntakeForm from './IntakeForm'
import logo from './logo.svg'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)
    this.handleIntakeSubmit = this.handleIntakeSubmit.bind(this)
  }

  handleIntakeSubmit(formValues) {
    const { dispatch } = this.props
    dispatch(createLeader(formValues))
  }

  render() {
    return (
      <div className="App">
        <div className="App-header">
          <a href="https://hackclub.com" target="_blank">
            <img src={logo} className="App-logo" alt="logo" />
          </a>
          <h1 className="App-party-popper">🎉</h1>
          <h2>Welcome to Hack Club!</h2>
        </div>
        <IntakeForm onSubmit={this.handleIntakeSubmit}/>
      </div>
    )
  }
}

App.propTypes = {
  dispatch: PropTypes.func.isRequired
}

function mapStateToProps(state) {
  return {}
}

export default connect(mapStateToProps)(App)
