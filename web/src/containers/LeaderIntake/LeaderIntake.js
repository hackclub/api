import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as intakeActions from '../../redux/modules/leaderIntake'
import { load as loadClubs } from '../../redux/modules/clubs'
import { SubmissionError } from 'redux-form'
import { Card, Header, Heading, LeaderIntakeForm, Link } from '../../components'
import colors from '../../styles/colors'

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

  handleSubmit(values) {
    const { submit } = this.props

    return submit(values)
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  componentDidMount() {
    const { loadClubs } = this.props

    loadClubs()
  }

  render() {
    const { status, clubs } = this.props

    return (
      <div>
        <Helmet title="Leader Intake" />
        <Header>
          <Link style={styles.headerLink} to="/">← Back to Home Page</Link>
          <Heading style={styles.headerText}>Welcome to Hack Club! Let's get you set up.</Heading>
        </Header>
        <Card style={styles.card}>
          <LeaderIntakeForm
              onSubmit={values => this.handleSubmit(values)}
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
