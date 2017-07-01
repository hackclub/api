import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import Axios from 'axios'
import { NavBar } from '../../components'
import { NotFound } from '../../containers'

const baseUrl = 'https://api.hackclub.com/v1/workshops/'

class WorkshopWrapper extends Component {
  getInitialState() {
    return {
      path: this.props.routeParams.splat || '',
      notFound: false
    }
  }

  componentDidMount() {
    Axios.get(baseUrl + this.state.path)
      .then(resp => {
        this.setState({
          workshopContent: resp.data,
        })
      })
      .catch(e => {
        // TODO: Handle non-404 errors
        this.setState({
          notFound: true
        })
      })
  }

  createWorkshop() {
    return {__html: this.state.workshopContent}
  }

  render() {
    return(
      <div>
       <Helmet title={this.state.path || 'Workshops'} />
       <NavBar />
       { this.state.notFound ? <NotFound /> : <div dangerouslySetInnerHTML={this.createWorkshop()} /> }
      </div>
    )
  }
}

export default Radium(WorkshopWrapper)
