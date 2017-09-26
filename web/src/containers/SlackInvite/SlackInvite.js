import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { withRouter } from 'react-router'

import colors from 'styles/colors'
import config from 'config'

import { connect } from 'react-redux'
import * as slackInviteActions from 'redux/modules/slackInvite'
import { SubmissionError } from 'redux-form'

import {
  Emoji,
  Header,
  Heading,
  LoadingSpinner,
  NotFound,
  Text,
} from 'components'

import SlackInviteFormWrapper from './SlackInviteFormWrapper/SlackInviteFormWrapper'

const styles = {
  heading: {
    color: colors.bg,
  },
  instructions: {
    fontSize: '22px',
    marginTop: '20px',
    color: colors.bg,
  }
}

class SlackInvite extends Component {
  static propTypes = {
    submit: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { params } = this.props
    const endpoint = `${config.apiBaseUrl}/v1/slack_invitation/strategies/`

    this.setState({
      loading: true,
      nameParam: params.name || 'default'
    })

    fetch(endpoint + this.state.nameParam)
      .then(response => {
        if (!response.ok) {
          throw Error(response.statusText);
        }
        return response.json()
      })
      .then(json => {
        this.setState({
          clubName: json.club_name,
          primaryColor: json.primary_color,
          stratId: json.id,
          loading: false
        })
      })
      .catch(e => {
        this.setState({ notFound: true })
      })
  }

  handleSubmit(values) {
    const { router, submit } = this.props
    const { nameParam, stratId } = this.state

    return submit(values.email, values.username, values.full_name, values.password, stratId)
      .then(response => {
        router.push(`/slack_invite/${nameParam}/${response.id}`)
      })
      .catch(error => {
        throw new SubmissionError(error.errors)
      })
  }

  content() {
    const { status } = this.props
    const { notFound, loading } = this.state

    if (notFound) {
      return <NotFound />
    } else if (loading) {
      return <LoadingSpinner />
    } else {
      return (<SlackInviteFormWrapper status={status}
                                      onSubmit={values => this.handleSubmit(values)}/>)
    }
  }

  render() {
    return (
      <div>
        <Helmet title="Slack Invite" />

        <Header>
          <Heading>
            <Emoji type="waving_hand_sign" />
          </Heading>

          <Heading style={styles.heading}>Join the Hack Club Slack!</Heading>

          <Text style={styles.instructions}>
            Provide us with some information, and we'll generate an account for you!
          </Text>
        </Header>

        {this.content()}
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.slackInvite.status
})

export default connect(
  mapStateToProps,
  {...slackInviteActions}
)(withRouter(Radium(SlackInvite)))
