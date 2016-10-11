import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as intakeActions from '../../redux/modules/leaderIntake'
import { Card, LeaderIntakeForm } from '../../components'

const styles = {
  card: {
    marginLeft: 'auto',
    marginRight: 'auto'
  }
}

class LeaderIntake extends Component {
  static propTypes = {
    error: PropTypes.string,
    loading: PropTypes.bool
  }

  render() {
    const { submit } = this.props

    return (
      <div>
        <Helmet title="Leader Intake" />
        <Card style={styles.card}>
          <LeaderIntakeForm onSubmit={values => submit(values)}/>
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  error: state.leaderIntake.error,
  loading: state.leaderIntake.loading
})

export default connect(
  mapStateToProps,
  {...intakeActions}
)(Radium(LeaderIntake))
