import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import ApiClient from 'helpers/ApiClient'
import mediaQueries from 'styles/common'
import { LoadingSpinner, NavBar, NotFound } from 'components'
import PosterCard from './PosterCard/PosterCard'

const client = new ApiClient()
const styles = {
  wrapper: {
    height: '100%',
    width: '100%'
  },
  container: {
    display: 'flex',
    alignItems: 'center',
    flexWrap: 'wrap',
    justifyContent: 'space-evenly',
    [mediaQueries.mediumUp]: {
      margin: '1em'
    }
  }
}

class PostersPage extends Component {
  componentDidMount() {
    client
      .get('/v1/repo/clubs/posters/metadata.json')
      .then(data => {
        this.setState({
          images: data.images
        })
      })
      .catch(e => {
        console.log(e)
        this.setState({ notFound: true })
      })
  }

  content() {
    const { notFound, images } = this.state

    if (notFound) {
      return <NotFound />
    } else if (images) {
      return (
        <div style={styles.container}>
          {images.map((image, i) => {
            return <PosterCard src={image} key={i} />
          })}
        </div>
      )
    } else {
      return <LoadingSpinner />
    }
  }

  render() {
    return (
      <div style={styles.wrapper}>
        <Helmet title="Posters" />
        <NavBar />
        {this.content()}
      </div>
    )
  }
}

export default Radium(PostersPage)
