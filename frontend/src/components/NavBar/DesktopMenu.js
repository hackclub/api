import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../styles/common'
import { Link } from '../../components'

import logo from './logo.svg'

const styles = {
  container: {
    justifyContent: 'flex-end',
    height: '100%',
    [mediaQueries.smallUp]: {
      display: 'none'
    },
    [mediaQueries.mediumUp]: {
      display: 'flex'
    }
  },
  image: {
    height: '40%'
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
  logo: {
    // https://www.w3.org/TR/css-flexbox-1/#auto-margins
    marginRight: 'auto'
  }
}

class DesktopMenu extends Component {
  render(){
    const buttons = this.props.navigationButtons

    return(
      <div style={styles.container}>
        <Link to="/" style={[styles.links,styles.logo]}>
          <img src={logo} alt="Hack Club logo" style={styles.image} />
        </Link>

        { buttons.map(btn => { return <Link to={btn.to} style={[styles.links, btn.style]}>{btn.title}</Link>})}
      </div>
    )
  }
}

export default Radium(DesktopMenu)
