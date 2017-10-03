import React from 'react'
import Radium from 'radium'
import mediaQueries from 'styles/common'
import colors from 'styles/colors'
import config from 'config'
import { Card, Link, Subtitle } from 'components'

const styles = {
  card: {
    marginTop: '1em',
    [mediaQueries.mediumUp]: {
      margin: '1em'
    },
    transition: 'box-shadow 0.3s ease-in-out',
    ':hover': {
      boxShadow: `0px 1px 50px -10px ${colors.gray}`
    }
  },
  img: {
    width: '100%'
  },
  subtitle: {
    textAlign: 'center',
    marginTop: '1em'
  }
}

const PosterCard = props => {
  const src = `${config.apiBaseUrl}/v1/repo/clubs/posters/${props.src}`

  return (
    <Link href={props.src}>
      <Card style={styles.card}>
        <img
          alt={props.src}
          onLoad={props.onLoad}
          src={src}
          style={styles.img}
        />
        <Subtitle style={styles.subtitle}>{props.src}</Subtitle>
      </Card>
    </Link>
  )
}

export default Radium(PosterCard)
