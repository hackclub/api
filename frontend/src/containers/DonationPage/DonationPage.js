import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { Card, DonationForm, Heading, HorizontalRule, NavBar, } from '../../components'

import image from './piano.jpg'

const styles = {
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '40px',
    marginBottom: '40px',

    maxWidth: '1000px'
  },
  heading: {
    fontSize: '2.5rem'
  },
  subheading: {
    marginTop: '15px',
    fontSize: '1.5rem'
  },
  info: {
    marginBottom: '15px'
  },
  rule: {
    marginBottom: '20px',
    marginTop: '10px'
  },
  banner: {
    width: '100%'
  }
}

class Donations extends Component {
  render() {
    return (
      <div>
        <Helmet title="Donations" />

        <NavBar />

        <Card style={styles.card}>
          <div style={styles.info}>
            <Heading style={styles.heading}>Hack Club brings free coding clubs to high schools worldwide</Heading>

            <img alt="Hackers being happy" style={styles.banner} src={image} />

            <p style={styles.subheading}>It costs us just $3 each month to support a student in Hack Club.</p>
          </div>

          <HorizontalRule style={styles.rule} />

          <DonationForm />
        </Card>
      </div>
    )
  }
}

export default Radium(Donations)
