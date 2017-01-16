import React, { Component } from 'react'
import {
  Button,
  Card,
  Heading,
  Link,
  Text,
} from '../../../components'
import colors from '../../../styles/colors'

import { connect } from 'react-redux'
import {
  personTypes,
  preAppSubmitPersonType,
  preAppReset,
} from '../../../redux/modules/application'

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

    let failText = null
    let failEmail = null

    switch(personType) {
    case personTypes.teacher:
      failText = failText || (
        <Text>
          We've seen teachers have success making announcements in their
          classrooms about Hack Club and approaching students directly about
          starting a club.
        </Text>
      )
      failEmail = failEmail || "teachers@hackclub.com"
    case personTypes.parent:
      failText = failText || (
        <Text>
          We've seen parents have success sharing Hack Club with the local PTA
          and expressing interest in Hack Club to school administration.
        </Text>
      )
      failEmail = failEmail || "parents@hackclub.com"
    case personTypes.other:
      failEmail = failEmail || "team@hackclub.com"

      const reset = () => dispatch(preAppReset())

      return (
        <div>
          <Text>
            We hate to say it, but we're currently only accepting applications
            from students.
          </Text>
          {failText}
          <Text>
            That said, we'd really love to help where we can. Shoot us an email
            at <Link href={`mailto:${failEmail}`}>{failEmail}</Link> letting us
            know if we can be helpful in any way.
          </Text>
          <Button type="link" onClick={reset}>← Go back</Button>
        </div>
      )
    default:
      return <PreApplicationForm onSubmit={vals => this.handlePreAppSubmit(vals)} />
    }
  }

  render() {
    const { personType, dispatch } = this.props

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
