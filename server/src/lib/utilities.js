
const util = {};

util.twoDigits = (d) => {
    
}

util.DateToMysqlFormat = () => {
    let twoDigits = (d) => {
        if(0 <= d && d < 10) return '0' + d.toString();
        if(-10 < d && d < 0) return '-0' + (-1*d).toString();
        return d.toString();
    }

    let result;
    with (new Date()) {
        result = getUTCFullYear() + "-" + twoDigits(1 + getUTCMonth()) + "-" +
            twoDigits(getUTCDate()) + " " + twoDigits(getUTCHours()) + ":" +
            twoDigits(getUTCMinutes()) + ":" + twoDigits(getUTCSeconds());
    } 
    
    return result;
};

util.checkFieldInJson = (body, fields) => {
    if (!body) 
        throw new PersonalException(`JSON Invalid`, 'checkFieldInJson', '-4');
    let fieldsj = Object.keys(body);
    for (let i = 0; i < fields.length; ++i) {
        if (!(fieldsj[i] && fieldsj[i] == fields[i]))
            throw new PersonalException(`JSON Invalid`, `checkFieldInJson`, '-4');
    }
}

module.exports = util;
