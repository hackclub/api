import React, { Component } from 'react'
import {
  Link,
  Text,
} from '../../../components'
import { personTypes } from '../../../redux/modules/application'

class PreAppResults extends Component {
  customNotes(personType) {
    switch(personType) {
    case personTypes.teacher:
      return (
        <Text>
          We've seen teachers have success making announcements in their
          classrooms about Hack Club and approaching students directly about
          starting a club.
        </Text>
      )
    case personTypes.parent:
      return (
        <Text>
          We've seen parents have success sharing Hack Club with the local PTA
          and expressing interest in Hack Club to school administration.
        </Text>
      )
    default:
      return null
    }
  }

  email(personType) {
    switch(personType) {
    case personTypes.teacher:
      return "teacher@hackclub.com"
    case personTypes.parent:
      return "parents@hackclub.com"
    default:
      return "team@hackclub.com"
    }
  }

  render() {
    const { personType } = this.props

    let customNotes = this.customNotes(personType)
    let email = this.email(personType)

    return (
      <div>
        <Text>
          We hate to say it, but we're currently only accepting applications
          from students.
        </Text>
        {customNotes}
        <Text>
          That said, we'd really love to help where we can. Shoot us an email
          at <Link href={`mailto:${email}`}>{email}</Link> letting us know if we
          can be helpful in any way.
        </Text>
      </div>
    )
  }
}

export default PreAppResults
