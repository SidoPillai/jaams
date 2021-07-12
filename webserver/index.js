const express = require("express");
const bodyParser = require("body-parser");

class JaamsAPI {

    constructor() {
        this.app = express()
        this.initExpress()
        this.initExpressMiddleware()
        this.initControllers()
        this.start()
    }

    initExpress() {
        this.app.set("port", 8080)
    }

    initExpressMiddleware() {
        this.app.use(bodyParser.urlencoded({extended:true}))
        this.app.use(bodyParser.json());
    }

    initControllers() {
        require("./JaamsController.js")(this.app)
    }

    start() {
        let self = this
        this.app.listen(this.app.get("port"), () => {
            console.log(`Server listening on port: ${self.app.get("port")}`)
        })
    }
}

new JaamsAPI()