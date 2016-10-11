import React, { Component } from 'react'
import Radium from 'radium'
import Card from '../components/Card'
import Button from '../components/Button'
import dinosaur from './dinosaur.png'

const styles = {
  wrapper: {
    width: '100%',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  },
  img: {
    width: '100%'
  },
  btn: {
    marginTop: '15px'
  }
}

class NoMatch extends Component {
  render() {
    return (
      <div style={styles.wrapper}>
        <Card>
          <h1>Oh snap!</h1>
          <p>
            Looks like you're trying to reach a page that doesn't exist. Here's
            a dinosaur instead:
          </p>
          <img style={styles.img}
               src={dinosaur}
               alt="Dinosaur" />
          <Button type="link"
                  href="/"
                  style={styles.btn}>
            ← Go to back to home page
          </Button>
        </Card>
      </div>
    )
  }
}

export default Radium(NoMatch)
