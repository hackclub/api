import React, { Component } from 'react'
import Radium from 'radium'
import { Link as RouterLink } from 'react-router'
import colors from 'styles/colors'

const RadiumRouterLink = Radium(RouterLink)

const styles = {
  color: colors.primary,
  textDecoration: 'none',
  ':hover': {
    color: colors.fadedPrimary,
    textDecoration: 'underline'
  }
}

class Link extends Component {
  render() {
    // At some point I'd like to figure out a better model for this, but for now
    // passing a `to` attribute uses the react-router Link class. If `to` isn't
    // a passed parameter, then an anchor tag is used.
    const { to, href } = this.props

    if (to) {
      return (
        <RadiumRouterLink to={to} style={[styles, this.props.style]}>
          {this.props.children}
        </RadiumRouterLink>
      )
    }

    return (
      <a href={href} style={[styles, this.props.style]}>
        {this.props.children}
      </a>
    )
  }
}

export default Radium(Link)
