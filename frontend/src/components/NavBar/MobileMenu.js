import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../styles/common'
import colors from '../../styles/colors'
import { Link } from '../../components'

import hamburgerIcon from './Hamburger.svg'

const styles = {
  container: {
    [mediaQueries.mediumUp]: {
      display: 'none'
    }
  },
  hamburger: {
    height: '100%',
    border: '1px solid green'
  },
  hamburgerIcon: {
    height: '40%'
  },
  menu: {
    textAlign: 'center',
    width: '100%',
    backgroundColor: colors.disabled,
    fontSize: '2em'
  },
  links: {
    color: colors.text,
    textDecoration: 'none',
    marginTop: '20px',
    marginBottom: '20px',
    border: '1px solid red'
  },
  li: {
    marginTop: '20px'
  },
  image: {
    height: '40%'
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
    return <li style={styles.li}><Link to={button.to} style={[styles.links, button.style]}>{button.title}</Link></li>
  }

  renderMenu() {
    let buttons = this.props.navigationButtons

    if (!this.state.isMenuVisible) {
      return
    }

    return (
      <div style={styles.menu}>
        <ul>
          { buttons.map(btn => { return this.renderButton(btn) }) }
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
          <img src={hamburgerIcon} style={styles.hamburgerIcon} alt="Hamburger"/>
          { this.renderMenu() }
        </div>
      </div>
    )
  }
}

export default Radium(MobileMenu)
