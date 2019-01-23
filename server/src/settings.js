const express = require('express');
const morgan = require('morgan');
const bodyparse = require('body-parser');
const svm_router = require('./routes/routesmethods');

class Server {
    constructor(port) {
        this.app = express();
        this.port = process.env.PORT || port;
    }

    Settings() {
        // settings

        // Middleware
        this.app.use(morgan("dev"));
        this.app.use(bodyparse.urlencoded({ extended: false }));
        this.app.use(bodyparse.json());


        // Router
        this.app.use(require('./routes/'));
        this.app.use('/api/sm', svm_router);
    }

    Run() {
        this.Settings();
        this.app.listen(this.port, () => {
            console.log(`SERVER FORUM-DEV RUNNING PORT: ${this.port}`);
        });
    }
}

module.exports = new Server(3000);
