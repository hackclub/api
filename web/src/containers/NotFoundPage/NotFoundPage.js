import React, { Component } from 'react'
import Radium from 'radium'
import pattern from 'styles/pattern.png'
import { NavBar, NotFound } from 'components'

const styles = {
  height: '100%',
  minWidth: '100%',
  backgroundImage: `url(${pattern})`,
  backgroundSize: '450px'
}

const NotFoundPage = () => {
  return (
    <div style={styles}>
      <NavBar />
      <NotFound />
    </div>
  )
}

export default Radium(NotFoundPage)
