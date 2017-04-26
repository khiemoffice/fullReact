import React from 'react'

const ContestPreview = (contest) => {
    return (
        <div className="ContestPreview">
            <h2 className='category-name'>{contest.categoryName}</h2>
            <div className='contest-name'>{contest.contestName}</div>
        </div>)
}

export default ContestPreview