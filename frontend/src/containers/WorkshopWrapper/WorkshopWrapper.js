import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import Axios from 'axios'

import { NavBar, LoadingSpinner } from '../../components'
import { NotFound } from '../../containers'

import Workshop from './Workshop/Workshop'

const baseUrl = 'https://api.hackclub/v1/workshops/'

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
      workshopUrl: url
    })
  }

  handleError(e, url) {
    this.setState({
      notFound: true
    })
  }

  getInitialState() {
    return {
      notFound: null
    }
  }

  content() {
    if (this.state.notFound === null) {
      return (<LoadingSpinner />)
    } else if(this.state.notFound === false) {
      return (<Workshop markdown={this.state.markdown} workshopUrl={this.state.workshopUrl} />)
    } else {
      return (<NotFound />)
    }
  }

  render() {
    return(
      <div>
        <Helmet title={this.state.path || 'Workshops'} />
        <NavBar />
        {this.content()}
      </div>
    )
  }
}

export default Radium(WorkshopWrapper)
