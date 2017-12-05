// Router links are disabled while the site is transitioning to
// the lachlan.hackclub.com page.
import React from 'react'
import Radium from 'radium'
/* import { Link as RouterLink } from 'react-router'*/
import colors from 'styles/colors'

/* const RadiumRouterLink = Radium(RouterLink)*/

const styles = {
  color: colors.primary,
  textDecoration: 'none',
  ':hover': {
    color: colors.fadedPrimary,
    textDecoration: 'underline'
  }
}

const Link = props => {
  // At some point I'd like to figure out a better model for this, but for now
  // passing a `to` attribute uses the react-router Link class. If `to` isn't
  // a passed parameter, then an anchor tag is used.
  const { to, href } = props

  /* if (to) {
   *   return (
   *     <RadiumRouterLink to={to} style={[styles, props.style]}>
   *       {props.children}
   *     </RadiumRouterLink>
   *   )
   * }*/

  return (
    <a href={href || to} style={[styles, props.style]}>
      {props.children}
    </a>
  )
}

export default Radium(Link)
