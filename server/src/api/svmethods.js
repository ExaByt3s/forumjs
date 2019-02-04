const path = require('path');
const uuid = require('uuid/v1');

const db = require('../database/DBCommon');
const srt = require('../lib/secure_utils');
const { checkFieldInJson } = require('../lib/utilities');
const { PersonalException } = require('../lib/exception_handler');

const methods = {};

/* COD_ERROR
     0  : Successfully
    -1  : Error Token
    -2  : User not found
    -3  : Data incomplent
    -4  : JSON Invalid
    -5  : DB empty
    -6  : Incorrect data [login]
    -7  : User or Email exists [registered]
    -8  : Article not found
    -9  : Article not have likes
    -10 : Articles empty
    -11 : User not have image
    -12 : Not found notify
    -98 : Only for Developers
    -99 : Error query
    -999 : Connection error
 */

// utils methods return [ boolean, json ]
async function checkRequestJson(body, args) {
    try {
        checkFieldInJson(body, args);
        return [ true, null ];
    } catch (err) {
        if (err instanceof PersonalException) {
            console.error(`${err.GetRef()}: ${err.GetMessage()}`);
            return [ false, err.GetExceptionToJson() ];
        }
    }
}

async function checkToken(body) {
    try {
        let token = await db.GetTokenUser(body.id);
        if (token != body.token) 
            throw new PersonalException('Invalid Token.', 'TokenComprobate', '-1');
        return [ true, null ];
    } catch (err) {
        if (err instanceof PersonalException) {
            console.error(`${err.GetRef()}: ${err.GetMessage()}`);
            return [ false, err.GetExceptionToJson() ];
        }
    }
}

// Log In methods
/*
Request:
    {
        nickname:
        password:
    }
Response:
    {
        codError:
        id:
        token: [new_token] 
    }
 */
methods.login_user = async (req) => {
    let check = await checkRequestJson(req.body, ['nickname','password']);
    if (!check[0]) return check[1];
    try {
        let id = await db.LoginUser([req.body.nickname, req.body.password]);
        let new_token = await db.UpdateUserToken(id);
        return { codError: 0, id: id, token: new_token };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.error(err);
        return { codError: -999 };
    }
}

// Register methods
/*
Request:
    {
        nickname:
        lastname:
        firstname:
        email:
        password:
        image:
    }
Response:
    {
        codError:
    }
 */
methods.register_user = async (req) => {
    let check = await checkRequestJson(req.body, 
        ['nickname','lastname','firstname','email','password', 'image']);
    if (!check[0]) return check[1];
    try {
        // process img
        let path_img = 'none';
        if (req.body.image != '') {
            //path_img = path.join(__dirname + '/storage/images/profile/' + uuid());
            path_img = 'storage/images/profile/' + uuid() + '.img';
            srt.decode64(req.body.image, path_img); 
        }

        let result = await db.RegisterUser([
            req.body.nickname,
            req.body.lastname,
            req.body.firstname,
            req.body.email,
            req.body.password,
            path_img
        ]);

        return result ? {
            codError: 0
        } : {
            codError: -999
        };
    } catch (err) {
        if (err instanceof PersonalException) {
            console.error(`${err.GetRef()}: ${err.GetMessage()}`);
            return err.GetExceptionToJson();
        }
        console.error(err);
        return { codError: -999 };
    }
}

// Getters methods
/*
Request:
    {}
Response:
    {
        codError
    }
 */
methods.get_status = async () => {
    return {
        codError: 0
    };
}

/*
Request:
    {
        id=useri, token=current token
    }
Response:
    {
        codError: 
        data: [ 
            { 
                acc_id:
                range:
                nickname:
                lastname:
                firstname:
                email: 
                create_at:  timestamp
            } 
        ]
    }
 */
methods.get_allusers = async (req) => {
    let check = await checkRequestJson(req.body, ['id', 'token']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetAllUsers();
        return { codError: 0, data: rows };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        return { codError: -99 };
    }
}

/*
Request:
    {
        id:
        token:
        req_id: 
    }
Response:
    {
        codError:
        data: [
            {
                acc_id:
                range:
                nickname:
                lastname:
                firstname:
                email: 
                create_at:  timestamp
            }
        ]
    }
*/
methods.get_user = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','req_id']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetUserById(req.body.req_id);
        return { codError: 0, data: rows };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        return { codError: -999 };
    }
}

/*
Request:
    {
        ac_id: propietario de la publicacion
        range: default(1)
        title:
        description:
        image: base64
    }
Response:
    {
        codError:
    }
*/
methods.push_article = async (req) => {
    let check = await checkRequestJson(req.body, 
        ['ac_id','range','title','description','image']);
    if (!check[0]) return check[1];
    try {
        let path_img = 'none'; 
        if (req.body.image != '') {
            path_img = 'storage/images/articles/' + uuid() + '.img';
            srt.decode64(req.body.image, path_img);
        }
        let result = await db.PushArticle([
            req.body.ac_id,
            req.body.range,
            req.body.title,
            req.body.description,
            path_img
        ]);

        if (result) {
            let art_last_id = GetLastArticleByOwner(req.body.ac_id);
            db.InternalPushGNotification([req.body.ac_id, art_last_id]);
        }

        return result ? {
            codError: 0
        } : {
            codError: -999
        };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.log(err);
        return { codError: -999 };
    }
}

/*
Request:
    {
        id:
        token:
        offset: 
    }
Response:
    {
        codError:
        length:
        data: [
            {
                ar_id:
                owner:
            }
        ]
    }
*/
methods.get_articles = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','offset']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetArticles(req.body.offset);
        let arr_data = [];
        for (let row of rows) {
            arr_data.push({
                ar_id: row.ar_id,
                owner: row.ac_id
            });
        }
        return { codError: 0, length: arr_data.length, data: arr_data };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        return { codError: -999 };
    }
}

/*
Request:
    {
        id:
        token:
        ar_id:
    }
Response:
    {
        codError:
        length:
        data: {
            ar_id:
            ac_id:
            range:
            title:
            description:
            create_at:
            image:
        }
    }
*/
methods.get_article = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','ar_id']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let row = await db.GetArticleById(req.body.ar_id);
        let article = {
            //ar_id: row.ar_id,
            ac_id: row.ac_id,
            range: row.range,
            title: row.title,
            description: row.description,
            create_at: row.create_at,
            image: srt.encode64(row.image_p)
        };
        return { codError: 0, data: article };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.log(err);
        return { codError: -999 };
    }
}

/*
Request:
    {
        id
        token
    }
Response:
    {
        codError:
        length:
        data: [
            {
                nt_id:
                type:
                info_id:
            }
        ]
    }
*/
methods.get_usernotifications = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetUserNotifications(req.body.id);
        let arr_nf = [];
        for (let row of rows) {
            arr_nf.push({
                nt_id: row.unt_id,
                type: row.type,
                info_id: row.info_id 
            });
        }
        return { codError: 0, length: arr_nf.length, data: arr_nf };
    } catch(err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.log(err);
        return { codError: -999 };
    }
}

/*
Request:
    {
        id
        token
        offset  // no implementado todavia
    }
Response:
    {
        codError:
        length:
        data: [
            {
                nt_id:
                type:
                info_id:
            }
        ]
    }
*/
methods.get_globalnotifications = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','offset']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetGlobalNotifications(req.body.offset);
        let arr_nf = [];
        for (let row of rows) {
            arr_nf.push({
                nt_id: row.gnt_id,
                type: row.type,
                info_id: row.info_id 
            });
        }
        return { codError: 0, length: arr_nf.length, data: arr_nf };
    } catch(err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.log(err);
        return { codError: -999 };
    }
}

/*
Request:
    {
        id
        token
        nt_id
    }
Response:
    {
        codError:
    }
*/
methods.confirm_unotification = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','nt_id']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        await db.ConfirmUserNotification(req.body.id, req.body.nt_id);
        return { codError: 0 };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        console.log(err);
        return { codError: -999 };
    }
}


/*
Request:
    {
        id
        token
        id_usr
    }
Response:
    {
        codError
        image
    }
 */
methods.get_userphoto = async (req) => {
    let check = await checkRequestJson(req.body, ['id','token','id_usr']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let row = await db.GetUserImage(req.body.id_usr);
        let b64 = srt.encode64(row);
        return { codError: 0, image: b64 };
    } catch (err) {
        if (err instanceof PersonalException) {
            return err.GetExceptionToJson();
        }
        return { codError: -999 };
    }
}

// in dev
/*
Request:
    {
        secret_key: // is nganga
    }
Response:
    {
        codError
    }
 */
methods.delete_all_info = async (req) => {
    let check = await checkRequestJson(req.body, ['secret_key']);
    if (!check[0]) return check[1];

    if (req.body.secret_key != 'nganga') {
        return { codError: -98 };
    }

    let result = await db.ClearTables();
    return result ? { codError: 0 } : { codError: -99 };
}

module.exports = methods;
