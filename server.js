import config from './config'
import apiRouter from './api'
import sassMiddleware from 'node-sass-middleware'
import path from 'path'

import serverRender from './serverRender'
console.log(serverRender)

import express from 'express'
const server = express()

server.use(sassMiddleware({
    src: path.join(__dirname, 'scss'),
    dest: path.join(__dirname, 'public')
}))
server.set('view engine', 'ejs')
server.use(express.static('./public'))

server.get('/', (req, res) => {
    serverRender()
        .then(content => {

            res.render('index', {
                content
            })
        })
        .catch(console.info)

})
server.use('/api', apiRouter)

server.listen(config.port, config.host, () => {
    console.info('express listeinng on port ', config.port)
})