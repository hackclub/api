import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as intakeActions from '../../redux/modules/leaderIntake'
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
    errors: PropTypes.object,
    status: PropTypes.string
  }

  render() {
    const { submit, status, errors } = this.props

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
             errors={errors}
            />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  errors: state.leaderIntake.errors,
  status: state.leaderIntake.status
})

export default connect(
  mapStateToProps,
  {...intakeActions}
)(Radium(LeaderIntake))
