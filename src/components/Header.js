import React from 'react'

class Header extends React.Component {
    state = {
        pageHeader: "name contests"
    }

    render() {
        return (
            <header className="header text-center"> {this.state.pageHeader}</header>
        )
    }

}

export default Header