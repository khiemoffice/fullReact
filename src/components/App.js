import React from 'react'
import Header from './header'
import ContestPreview from './contestPreview'

import axios from 'axios'
class App extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            pageHeader: 'nameing contests',
            contests: this.props.initialContests
        }
    }

    componentDidMount() {
        axios.get('/api/contests')
            .then(resp => {
                console.log(resp.data.contests)
                this.setState({
                    contests: resp.data.contests
                })
            })
            .catch(console.error)
        //this.setState({
        //contests: data.contests
        //})
    }
    render() {
        return (
            <div >
                <Header message={this.state.pageHeader} />
                <div>
                    {this.state.contests.map(item =>
                        <ContestPreview key={item.id} { ...item } />
                    )}
                </div>

            </div >

        )
    }
}

export default App