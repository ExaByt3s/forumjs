const { Router } = require('express');
const path = require('path');

const router = new Router(); 

router.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../views/security.html'));
});

module.exports = router;
