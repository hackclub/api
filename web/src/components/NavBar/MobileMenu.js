import React, { Component } from 'react'
import Radium from 'radium'
import PropTypes from 'prop-types'
import { mediaQueries } from 'styles/common'
import colors from 'styles/colors'
import { Link } from 'components'

import burgerIcon from './burger.svg'
import logo from './logo.svg'

const styles = {
  wrapper: {
    textAlign: 'center',
    [mediaQueries.mediumUp]: {
      display: 'none'
    },
    [mediaQueries.print]: {
      display: 'none'
    }
  },
  burgerButton: {
    position: 'absolute',
    top: '0',
    left: '0',
    height: '1.5em',
    width: '1.5em',
    margin: '1em',
  },
  menu: {
    textAlign: 'center',
    paddingTop: '1em',
    paddingBottom: '1em',
  },
  links: {
    fontSize: '2em',
    color: 'white',
    textDecoration: 'none',
    display: 'block',
    width: '100%',
    paddingTop: '0.5em',
    paddingBottom: '0.5em',
    ':hover': {
      color: 'white',
    }
  },
  logo: {
    height: '1.5em',
    margin: '1em auto',
  }
}

class MobileMenu extends Component {
  static propTypes = {
    navigationButtons: PropTypes.array
  }

  constructor(props) {
    super(props)

    this.state = { isMenuVisible: false }

    this.toggleMenuVisibility = this.toggleMenuVisibility.bind(this)
  }

  toggleMenuVisibility() {
    this.setState({ isMenuVisible: !this.state.isMenuVisible })
  }

  renderMenu() {
    let { isMenuVisible } = this.state
    let { navigationButtons } = this.props

    if (!isMenuVisible) {
        return (<img src={logo} alt="Hack Club logo" style={styles.logo} />)
    }

    return (navigationButtons.map((btn, i) => {
      return (
        <div style={styles.menu} key={i}>
          <Link to={btn.to} href={btn.href} style={[styles.links,btn.style]} >
            {btn.title}
          </Link>
        </div>
      )
    }))
  }

  render() {
    return (
      <div style={styles.wrapper}>
        <img src={burgerIcon}
             style={styles.burgerButton}
             onClick={this.toggleMenuVisibility}
             alt="menu button"
        />
        {this.renderMenu()}
      </div>
    )
  }
}

export default Radium(MobileMenu)
