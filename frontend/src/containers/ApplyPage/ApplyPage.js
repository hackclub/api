import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { connect } from 'react-redux'
import * as applyActions from '../../redux/modules/apply'
import { SubmissionError } from 'redux-form'

import ApplyInfo from './ApplyInfo/ApplyInfo'
import ApplyHeading from './ApplyHeading/ApplyHeading'

import {
  NavBar,
  Container,
  ApplicationForm,
  Card
} from '../../components'

import { mediaQueries } from '../../styles/common'

const styles = {
  wrapper: {
    marginLeft: 'auto',
    marginRight: 'auto',
    textAlign: 'center',
    paddingTop: '25px',
    paddingBottom: '25px',
    [mediaQueries.mediumUp]: {
      backgroundSize: '450px',
      paddingTop: '50px',
      paddingBottom: '60px'
    }
  },
  hr: {
    width: '80%',
    height: '4px',
    marginTop: '-2px',
    marginLeft: 'auto',
    marginRight: 'auto',
    marginBottom: 0,
    [mediaQueries.mediumUp]: {
      width: '70%',
      height: '5px',
      marginTop: '-2.5px'
    }
  },
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '1000px'
  }
}

class Apply extends Component {
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

  render() {
    return (
      <div>
        <Helmet title="Apply" />

        <NavBar />
        <Container style={[styles.wrapper]}>
          <ApplyHeading />

          <ApplyInfo />
        </Container>

        <Card style={[styles.card]}>
          <ApplicationForm onSubmit={values => this.handleSubmit(values)} status={status} />
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  status: state.apply.status
})

export default connect(
  mapStateToProps,
  {...applyActions}
)(Radium(Apply))
