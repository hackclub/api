import React, { Component } from 'react'
import {
  Button,
  Card,
  Heading,
} from '../../../components'
import colors from '../../../styles/colors'

import { connect } from 'react-redux'
import {
  personTypes,
  preAppSubmitPersonType,
  preAppReset,
} from '../../../redux/modules/application'

import NotStudentMessage from './NotStudentMessage'
import PreApplicationForm from './PreApplicationForm'

const styles = {
  wrapper: {
    backgroundColor: colors.primary,
    paddingTop: '60px',
    paddingBottom: '60px'
  },
  heading: {
    textAlign: 'center',
    color: colors.bg,
    fontSize: '36px'
  },
  card: {
    marginTop: '50px',
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '450px'
  }
}

class ApplyForm extends Component {
  handlePreAppSubmit(vals) {
    const { dispatch } = this.props
    const { person_type: personType } = vals

    dispatch(preAppSubmitPersonType(personType))
  }

  contentsOfCard() {
    const { personType, dispatch } = this.props

    if (personType) {
      const reset = () => dispatch(preAppReset())

      return (
        <div>
          <NotStudentMessage personType={personType} />
          <Button type="link" onClick={reset}>← Go back</Button>
        </div>
      )
    } else {
      return <PreApplicationForm onSubmit={vals => this.handlePreAppSubmit(vals)} />
    }
  }

  render() {
    const { personType } = this.props

    if (personType === personTypes.student) {
      window.location = 'https://hackclub.com/apply'
    }

    return (
      <div style={styles.wrapper}>
        <Heading style={styles.heading}>Start Your Application</Heading>
        <Card style={styles.card}>
          {this.contentsOfCard()}
        </Card>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  personType: state.application.preApplication.personType
})

export default connect(mapStateToProps)(ApplyForm)
