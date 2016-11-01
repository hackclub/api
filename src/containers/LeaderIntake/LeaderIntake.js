import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as intakeActions from '../../redux/modules/leaderIntake'
import { load as loadClubs } from '../../redux/modules/clubs'
import { Card, Header, Heading, LeaderIntakeForm, Link } from '../../components'
import colors from '../../colors'

const styles = {
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
    status: PropTypes.string
  }

  componentDidMount() {
    const { loadClubs } = this.props

    loadClubs()
  }

  render() {
    const { submit, status, clubs } = this.props

    return (
      <div>
        <Header>
          <Link style={[styles.headerLink]} to="/">← Back to Home Page</Link>
          <Heading style={styles.headerEmoji}>🎉</Heading>
          <Heading style={styles.headerText}>Welcome to Hack Club! Let's get you set up.</Heading>
        </Header>
        <Helmet title="Leader Intake" />
        <Card style={styles.card}>
          <LeaderIntakeForm
              onSubmit={values => submit(values)}
              status={status}
              clubs={clubs}
            />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.leaderIntake.status,
  clubs: state.clubs.data
})

export default connect(
  mapStateToProps,
  {...intakeActions, loadClubs}
)(Radium(LeaderIntake))
