const sha512 = require('js-sha512').sha512;
const crypt = require('crypto-js');
const fs = require('fs');
const security = {};

// HASH
security.mkHashSHA512 = (text) => {
    return sha512(text.toString());
}

security.cmpHashSHA512 = (hash, key) => {
    return hash == sha512(key);
}

// Base64
security.base64_encode = (file) => {
    let bitmap = fs.readFileSync(file);
    return new Buffer(bitmap).toString('base64');
}

security.base64_decode = (base64str, file) => {
    let bitmap = new Buffer(base64str, 'base64');
    fs.writeFileSync(file, bitmap);
}

// CRYPT
security.mkEncryptAES = (text, password) => {
    let encrypt = crypt.AES.encrypt(text, password);
    return [ 
        encrypt,    // encrypt
        password    // password
    ];
}

security.mkDecryptAES = (encrypt, password) => {
    let decrypt = crypt.AES.decrypt(encrypt, password);
    return [
        decrypt.toString(crypt.enc.Utf8),   // decrypt value
        decrypt                             // decrypt reference
    ];
}

module.exports = security;
