import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../styles/common'
import { Link } from '../../components'

import logo from './logo.svg'

const styles = {
  container: {
    justifyContent: 'flex-start',
    height: '100%',
    [mediaQueries.smallUp]: {
      display: 'none'
    },
    [mediaQueries.mediumUp]: {
      display: 'flex'
    }
  },
  links: {
    color: 'white',
    textDecoration: 'none',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    paddingRight: '20px',
    paddingLeft: '20px',
    ':hover': {
      background: 'rgba(0,0,0,0.2)'
    }
  },
  image: {
    height: '40%'
  }
}

class DesktopMenu extends Component {
  render(){
    const buttons = this.props.navigationButtons

    return(
      <div style={styles.container}>
        <Link to="/" style={styles.links}>
          <img src={logo} alt="Hack Club logo" style={styles.image} />
        </Link>

        { buttons.map(btn => { return <Link to={btn.to} style={[styles.links, btn.style]}>{btn.title}</Link>})}
      </div>
    )
  }
}

export default Radium(DesktopMenu)
