import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import Axios from 'axios'

import config from '../../config'
import { mediaQueries } from '../../styles/common'
import { NavBar, LoadingSpinner } from '../../components'
import { NotFound } from '../../containers'

import Workshop from './Workshop/Workshop'

const baseUrl = config.apiBaseUrl + '/v1/workshops/'

const styles = {
  pageWrapper: {
    height: '100%'
  },
  workshopWrapper: {
    margin: '10px auto',
    height: '100%',
    padding: '1em',
    [mediaQueries.mediumUp]: {
      maxWidth: '75%',
      width: '750px'
    }
  }
}

class WorkshopWrapper extends Component {
  constructor(props) {
    super(props)

    var rootUrl = baseUrl + 'README.md'
    var extendedUrl = baseUrl + props.routeParams.splat
    var url = (props.routeParams.splat ? extendedUrl : rootUrl)

    this.requestWorkshop(url)
  }

  requestWorkshop(url) {
    Axios.get(url)
      .then(resp => this.placeWorkshop(resp.data, url))
      .catch(e => this.handleError(e, url))
  }

  placeWorkshop(data, url) {
    this.setState({
      notFound: false,
      markdown: data,
      imagesUrl: url
    })
  }

  handleError(e, url) {
    var isNotFound = e.request && e.request.status === 404
    var isNotReadme = !/README.md$/.test(url)

    if (isNotFound && isNotReadme) {
      url = `${url}/README.md`

      this.requestWorkshop(url)
    } else {
      this.setState({
          notFound: true
      })
    }
  }

  getInitialState() {
    return {
      notFound: null
    }
  }

  content() {
    var { notFound, markdown, imagesUrl } = this.state
      var { location } = this.props

    if (notFound === true) {
      return (<NotFound />)
    } else if(notFound === false) {
        return (<Workshop markdown={markdown} imagesUrl={imagesUrl} location={location} />)
    } else {
      return (<LoadingSpinner />)
    }
  }

  render() {
    return(
      <div style={styles.pageWrapper}>
        <Helmet title={this.state.path || 'Workshops'} />
        <NavBar />
        <div style={styles.workshopWrapper}>
          {this.content()}
        </div>
      </div>
    )
  }
}

export default Radium(WorkshopWrapper)
