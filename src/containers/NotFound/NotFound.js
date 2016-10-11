import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import {
  Button,
  Card,
  Header,
  Text
} from '../../components'
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

class NotFound extends Component {
  render() {
    return (
      <div style={styles.wrapper}>
        <Helmet title="¯\_(ツ)_/¯" />
        <Card>
          <Header>Oh snap!</Header>
          <Text>
            Looks like you're trying to reach a page that doesn't exist. Here's
            a dinosaur instead:
          </Text>
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

export default Radium(NotFound)
