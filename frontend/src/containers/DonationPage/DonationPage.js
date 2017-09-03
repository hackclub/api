import React from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { Card, DonationForm, Heading, HorizontalRule, NavBar } from '../../components'

const styles = {
  card: {
    boxSizing: 'border-box',

    marginLeft: 'auto',
    marginRight: 'auto',
    marginTop: '3rem',
    marginBottom: '3rem',

    maxWidth: '48rem'
  },
  heading: {
    fontSize: '2rem'
  },
  subheading: {
    fontSize: '1.5rem'
  },
  info: {
    lineHeight: '1.5',
    marginBottom: '2rem'
  },
  rule: {
    marginBottom: '2rem'
  }
}

const Donations = () =>
  <div>
    <Helmet title="Donate" />

    <NavBar />

    <Card style={styles.card}>
      <div style={styles.info}>
        <Heading style={styles.heading}>
          Hack Club brings free coding clubs to high schools worldwide
        </Heading>

        <p style={styles.subheading}>
          It costs us just $3 each month to support a student in Hack Club.
        </p>
      </div>

      <HorizontalRule style={styles.rule} />

      <DonationForm />
    </Card>
  </div>

export default Radium(Donations)
