import React from 'react'
import ReactDom from 'react-dom'
import App from './components/App'
import { Router, Route } from 'react-router-dom'

class Haha extends React.Component {
    render() {
        return (<h1>Hi</h1>);
    }
}


ReactDom.render(
    <Router>
        <Route path="/" component={Haha} />
        <Route path="/haha" component={App} />
    </Router>
    ,
    document.getElementById('root')
)

