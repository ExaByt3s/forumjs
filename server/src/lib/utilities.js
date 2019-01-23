const secure = require('./secure_utils');

function twoDigits(d) {
    if(0 <= d && d < 10) return '0' + d.toString();
    if(-10 < d && d < 0) return '-0' + (-1*d).toString();
    return d.toString();
}

function DateToMysqlFormat() {
    let result;
    with (new Date()) {
        result = getUTCFullYear() + "-" + twoDigits(1 + getUTCMonth()) + "-" +
            twoDigits(getUTCDate()) + " " + twoDigits(getUTCHours()) + ":" +
            twoDigits(getUTCMinutes()) + ":" + twoDigits(getUTCSeconds());
    }
    return result;
};

function GenerateToken(id) {
    let years = 1000 * 60 * 60 * 24 * 365;
    let token = secure.mkHashSHA512(id + Math.round(new Date().getTime() / years));
    return token;
}

class PersonalException {
    constructor(msg, ref_fn, cerror) {
        this.excp = {
            message: msg,
            reference: ref_fn,
            codError: cerror
        };
    }

    GetMessage() {
        return this.excp.message;
    }

    GetRef() {
        return this.excp.reference;
    }

    GetExceptionToJson() {
        return { codError: this.excp.codError };
    }
}

function checkFieldInJson(body, fields) {
    if (!body) 
        throw new PersonalException(`JSON Invalid`, 'checkFieldInJson', '-4');
    let fieldsj = Object.keys(body);
    for (let i = 0; i < fields.length; ++i) {
        if (!(fieldsj[i] && fieldsj[i] == fields[i]))
            throw new PersonalException(`JSON Invalid`, `checkFieldInJson`, '-4');
    }
}

module.exports = {
    // funcs 
    GenerateToken, DateToMysqlFormat, checkFieldInJson,
    // classes
    PersonalException 
};
