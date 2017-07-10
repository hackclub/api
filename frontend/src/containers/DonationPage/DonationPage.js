import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import { NavBar, Header, Heading } from '../../components'

import { mediaQueries } from '../../styles/common'

const backgroundImageURL = "https://hackclub.com/assets/hack_huddle-303bc7a97c39497fcbeea6f73d34095c.jpg"

const styles = {
  heading: {
    color: 'white',
    fontSize: '2.625rem',
    fontWeight: 'bold',
    lineHeight: 1.4
  },
  subheading: {
    color: 'white',
    fontSize: '2rem',
    lineHeight: 1.6
  },
  inner: {
    [mediaQueries.mediumUp]: {
      width: '80%',
      paddingLeft: '100px',
      paddingRight: '100px'
    }
  }
}

const attentionStyles = {
  backgroundImage: `url(${backgroundImageURL})`,
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  paddingTop: '100px',
  paddingBottom: '100px',

  paddingLeft: '15px',
  paddingRight: '15px',

  color: 'white',
}

class Donations extends Component {
  render() {
    return (
      <div>
        <Helmet title="Donations" />

        <NavBar />

        <div style={attentionStyles}>
          <div style={styles.inner}>
            <Heading style={styles.heading}>Hack Club brings free coding clubs to high schools worldwide.</Heading>

            <p style={styles.subheading}>It costs us $3 each month to support a student in a Hack Club. Join us, your contribution matters.</p>
          </div>
        </div>
      </div>
    )
  }
}

export default Radium(Donations)
