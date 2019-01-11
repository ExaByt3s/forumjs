const { Router } = require('express');
const svm = require('./svmethods');

const svm_router = new Router();

// login
svm_router.post('/login', async (req, res) => {
    res.json(await svm.login_user(req));
});

// register
svm_router.post('/signin', async (req, res) => {
    res.json(await svm.register_user(req));
});

// getters
svm_router.post('/getstatus', async (req, res) => {
    res.json(await svm.get_status());
});

svm_router.post('/getallusers', async (req, res) => {
    res.json(await svm.get_allusers(req));
});

svm_router.post('/getuser', async (req, res) => {
    res.json(await svm.get_user(req));
});

// in dev
svm_router.post('/reset_db', async (req, res) => {
    res.json(await svm.delete_all_info(req));
});

module.exports = svm_router;