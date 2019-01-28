const sha512 = require('js-sha512').sha512;
const crypt = require('crypto-js');
const fs = require('fs');

const sct = {};

// HASH512
sct.mkHashSHA512 = (text) => {
    return sha512(text.toString());
}

sct.cmpHashSHA512 = (hash, key) => {
    return hash == sha512(key);
}

// Base64
sct.encode64 = (file) => {
    let bitmap = fs.readFileSync(file);
    return new Buffer(bitmap).toString('base64');
}

sct.decode64 = (base64str, file_path) => {
    let buffer = new Buffer(base64str, 'base64');
    fs.writeFileSync(file_path, buffer);
}

// Interal manager
sct.GenerateToken = (id) => {
    let years = 1000 * 60 * 60 * 24 * 365;
    let token = sct.mkHashSHA512(id + Math.round(new Date().getTime() / years));
    return token;
}

// CRYPT
sct.mkEncryptAES = (text, password) => {
    let encrypt = crypt.AES.encrypt(text, password);
    return [ 
        encrypt,    // encrypt
        password    // password
    ];
}

sct.mkDecryptAES = (encrypt, password) => {
    let decrypt = crypt.AES.decrypt(encrypt, password);
    return [
        decrypt.toString(crypt.enc.Utf8),   // decrypt value
        decrypt                             // decrypt reference
    ];
}

module.exports = sct;
