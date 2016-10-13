import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import { Card, Cloud9SetupForm, Header, Text } from '../../components'
import * as cloud9SetupActions from '../../redux/modules/cloud9Setup'

const styles={
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '40px',
    marginBottom: '40px'
  },
  form: {
    marginTop: '15px'
  }
}

class Cloud9Setup extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired
  }

  render() {
    const { errors, submit, status } = this.props

    return (
      <div>
        <Helmet title="Cloud9 Setup" />
        <Card style={styles.card}>
          <Header>Cloud9 Setup</Header>
          <Text>
            You'll need an invite to use Cloud9 at Hack Club. Fill out the below
            form and check your inbox to get one.
          </Text>
          <Cloud9SetupForm
             style={styles.form}
             status={status}
             errors={errors}
             onSubmit={values => submit(values.email)}
            />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  errors: state.cloud9Setup.errors,
  status: state.cloud9Setup.status
})

export default connect(
  mapStateToProps,
  {...cloud9SetupActions}
)(Radium(Cloud9Setup))
