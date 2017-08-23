import React, { Component } from 'react'
import Radium from 'radium'
import signature from './signature.png'
import { mediaQueries } from '../../../styles/common.js'
import { Card, Text } from '../../../components'

const styles = {
  card: {
    textAlign: 'left',
    maxWidth: '100%',
    borderRadius: '1px',
    [mediaQueries.smallUp]: {
      display: 'none'
    },
    [mediaQueries.mediumUp]: {
      padding: '4em',
      display: 'inherit',
    }
  },
  signature: {
    width: '9em',
    marginBottom: '-2em',
    marginTop: '-2em',
  },
  signatureLine: {
    marginBottom: '0'
  }
}

class ApplyInfo extends Component {
  render() {
    return (
      <Card style={styles.card}>
        <Text>
          Dear applicant,
        </Text>
        <Text>
          At this point in Hack Club's history, we've worked with hundreds of high schoolers to start over 200 Hack Clubs.
        </Text>
        <Text>
          One of the things we've learned is that it's very difficult to predict a club's success from the initial leader's application. We've had clubs we nearly rejected succeed beyond expectation and we've had clubs we were excited about fail miserably.
        </Text>
        <Text>
          The one pattern we have noticed across nearly all clubs is that their success or failure is almost always a result of the club's leadership. The leaders make the club.
        </Text>
        <Text>
          Our best clubs are led by leaders that are gritty. By people who will stop at nothing to see their goals through. People who see challenges and instead of asking "why" ask "why not".
        </Text>
        <Text>
          Our best leaders are thoughtful. They think deeply about the world around them and break things down to their fundamentals. They look for simpler ways to do things, not accepting the status quo.
        </Text>
        <Text>
          Our best leaders are team players and understand it takes more than one person to build an institution at their school.
        </Text>
        <Text>
          Our goal with this application is to get a taste of who you are. Are you gritty? How do you think about the world? What are the deeply personal experiences you've had that have led you to applying today?
        </Text>
        <Text>
          These days, we accept nearly everyone who applies to start a Hack Club because we know how terrible we are at predicting success. But we do want you to take this seriously.
        </Text>
        <Text>
          Your answers to this application will determine how we’ll work with you. They'll tell us what kind of person you are, who you'll work with at Hack Club, and how we should help you get your club off the ground.
        </Text>
        <Text>
          We hope you'll understand what this application means to us.
        </Text>
        <Text>
          Sincerely,
        </Text>
        <img alt="Zach Latta" src={signature} style={styles.signature} />
        <Text style={styles.signatureLine}>Zach Latta</Text>
        <Text style={styles.signatureLine}>Executive Director</Text>
        <Text style={styles.signatureLine}>August 22, 2017</Text>
      </Card>
    )
  }
}

export default Radium(ApplyInfo)
