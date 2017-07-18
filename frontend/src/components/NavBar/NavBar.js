import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../styles/colors'
import { mediaQueries } from '../../styles/common'

import { Emoji } from '../../components'

import MobileMenu from './MobileMenu'
import DesktopMenu from './DesktopMenu'

const styles = {
  wrapper: {
    backgroundColor: colors.primary,
    marginLeft: 'auto',
    marginRight: 'auto',
    [mediaQueries.mediumUp]: {
      margin: 0,
      minHeight: '45px',
      height: '60px'
    }
  },
}

const navigationButtons = [
  {
    title: 'Home',
    to: '/'
  },
  {
    title: 'Our Team',
    to: '/team'
  },
  {
    title: 'Workshops',
    to: '/workshops'
  },
  {
    title: 'Donate',
    to: '/donate'
  },
  {
    title: <p>Start a Hack Club <Emoji type="airplane_departure" /></p>,
    to: '/start',
    style: {
      fontWeight: 'bold'
    }
  }
]

class NavBar extends Component {
  render() {
    return (
      <div style={[styles.wrapper,this.props.style]}>
        <DesktopMenu navigationButtons={navigationButtons} />
        <MobileMenu navigationButtons={navigationButtons} />
      </div>
    )
  }
}

export default Radium(NavBar)
