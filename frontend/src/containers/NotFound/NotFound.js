import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import {
  Button,
  Card,
  Emoji,
  Heading,
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
          <Heading>Oh snap!</Heading>
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
            <Emoji type="leftwards_black_arrow" /> Go to back to home page
          </Button>
        </Card>
      </div>
    )
  }
}

export default Radium(NotFound)
