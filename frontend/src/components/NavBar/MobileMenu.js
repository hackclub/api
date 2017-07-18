import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../styles/common'
import colors from '../../styles/colors'
import { Link } from '../../components'

import hamburgerIcon from './hamburger.svg'

const styles = {
  container: {
    [mediaQueries.mediumUp]: {
      display: 'none'
    }
  },
  hamburger: {
    height: '100%'
  },
  hamburgerIcon: {
      border: '1px solid',
      borderColor: colors.white,
      borderRadius: '5px',
      height: '1.8em',
      margin: '10px',
      padding: '10px'
  },
  image: {
    height: '40%'
  },
  links: {
    color: colors.white,
    marginBottom: '20px',
    marginTop: '20px',
    textDecoration: 'none'
  },
  li: {
    marginTop: '20px'
  },
  menu: {
    textAlign: 'center',
    width: '100%',
    backgroundColor: colors.primary,
    fontSize: '2em'
  }
}

class MobileMenu extends Component {
  constructor(props) {
    super(props)

    this.state = {
      isMenuVisible: false
    }

    this.toggleMenuVisibility = this.toggleMenuVisibility.bind(this)
  }

  renderButton(button) {
    return (
      <li style={styles.li}>
        <Link to={button.to} style={[styles.links, button.style]}>
        {button.title}
        </Link>
      </li>
    )
  }

  renderMenu() {
    let btns = this.props.navigationButtons

    if (!this.state.isMenuVisible) {
      return
    }

    return (
      <div style={styles.menu}>
        <ul>
        { btns.map(btn => { return this.renderButton(btn) }) }
        </ul>
      </div>
    )
  }

  toggleMenuVisibility() {
    this.setState({
      isMenuVisible: !this.state.isMenuVisible
    })
  }

  render(){
    return(
      <div style={styles.container}>
        <div onClick={this.toggleMenuVisibility} style={styles.hamburger}>
        <img src={hamburgerIcon} style={styles.hamburgerIcon} alt="Hamburger" />
        { this.renderMenu() }
        </div>
      </div>
    )
  }
}

export default Radium(MobileMenu)
