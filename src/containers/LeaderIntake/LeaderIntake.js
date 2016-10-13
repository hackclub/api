import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as intakeActions from '../../redux/modules/leaderIntake'
import { Card, Header, LeaderIntakeForm, Link } from '../../components'
import colors from '../../colors'

const styles = {
  header: {
    backgroundColor: colors.primary,
    color: colors.bg,

    textAlign: 'center',
    padding: '40px'
  },
  headerLink: {
    color: colors.bg,
    position: 'absolute',
    top: '20px',
    right: '15px',
    fontSize: '18px',
    textDecoration: 'none',

    ':hover': {
      textDecoration: 'underline'
    }
  },
  headerEmoji: {
    fontSize: '75px',
    marginBottom: '30px'
  },
  headerText: {
    color: colors.bg,
    marginBottom: '0'
  },
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '40px',
    marginBottom: '40px'
  }
}

class LeaderIntake extends Component {
  static propTypes = {
    error: PropTypes.string
  }

  render() {
    const { submit } = this.props

    return (
      <div>
        <div style={styles.header}>
          <Link style={[styles.headerLink]} to="/">← Back to Home Page</Link>
          <Header style={styles.headerEmoji}>🎉</Header>
          <Header style={styles.headerText}>Welcome to Hack Club! Let's get you set up.</Header>
        </div>
        <Helmet title="Leader Intake" />
        <Card style={styles.card}>
          <LeaderIntakeForm onSubmit={values => submit(values)}/>
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  error: state.leaderIntake.error
})

export default connect(
  mapStateToProps,
  {...intakeActions}
)(Radium(LeaderIntake))
