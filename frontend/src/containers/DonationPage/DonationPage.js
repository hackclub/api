import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { mediaQueries } from '../../styles/common'
import { Card, DonationForm, Heading, HorizontalRule, NavBar, } from '../../components'

const styles = {
  card: {
    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '40px',
    marginBottom: '40px',

    maxWidth: '1000px'
  },
  heading: {
    fontSize: '2rem'
  },
  subheading: {
    fontSize: '1.5rem'
  },
  info: {
    marginBottom: '30px'
  },
  rule: {
    marginBottom: '20px',
    marginTop: '10px'
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
