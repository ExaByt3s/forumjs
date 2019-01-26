const db = require('../database/DBCommon');
const { PersonalException, checkFieldInJson } = require('../lib/utilities');
const sec = ('../lib/secure_utils');
const path = require('path');
const uuid = require('uuid/v1');

/*
    Construir el cliente
 */

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
        token: [new_token] 
    }
 */
methods.login_user = async (req) => {
    let check = await checkRequestJson(req.body, ['nickname','password']);
    if (!check[0]) return check[1];
    try {
        let id = await db.LoginUser([req.body.nickname, req.body.password]);
        let new_token = await db.UpdateUserToken(id);
        return { codError: 0, token: new_token };
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
            path_img = path.join('/storage/images/profile/' + uuid());
            sec.base64_decode(req.body.image, path_img);
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
        image_p: base64
    }
Response:
    {
        codError:
    }
*/
methods.push_article = async (req) => {
    let check = await checkRequestJson(req.body, 
        ['ac_id','range','title','description','image_p']);
    if (!check[0]) return check[1];
    try {
        let path_img = 'none'; 
        if (image_p != '') {
            path_img = path.join('storage/images/articles/' + uuid());
            sec.base64_decode(req.body.image_p, path_img);
        }
        let result = await db.PushArticle([
            req.body.ac_id,
            req.body.range,
            req.body.title,
            req.body.description,
            path_img
        ]);
        return result ? {
            codError: 0
        } : {
            codError: -999
        };
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
        offset:
        token: 
    }
Response:
    {
        codError:
        data: [
            {
                a_id:
                ac_id:
                range:
                title:
                description:
                imagebase64:
                create_at:
            }
        ]
    }
*/
methods.get_articles = async (req) => {
    let check = await checkRequestJson(req.body, ['id','offset']);
    if (!check[0]) return check[1];
    //check = await checkToken(req.body);
    //if (!check[0]) return check[1];
    try {
        let rows = await db.GetArticles(req.body.offset);
        let arr_data = [];
        for (let row of rows) {
            arr_data.push({
                ar_id: row.ar_id,
                ac_id: row.ac_id,
                range: row.range,
                title: row.title,
                description: row.description,
                imagebase64: sec.base64_encode(row.image_p),
                create_at: row.create_at
            });
        }
        return { codError: 0, data: arr_data };
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
        ar_id:
        token:
    }
Response:
    {
        codError:
        data: [ 
            {
                ar_id:
                ac_id:
                range:
                title:
                description:
                imagebase64:
                create_at:
            }
        ]
    }
*/
methods.get_articles = async (req) => {
    let check = await checkRequestJson(req.body, ['id','ar_id']);
    if (!check[0]) return check[1];
    check = await checkToken(req.body);
    if (!check[0]) return check[1];
    try {
        let rows = await db.GetArticleById(req.body.ar_id);
        let arr_data = [];
        for (let row of rows) {
            arr_data.push({
                ar_id: row.a_id,
                ac_id: row.ac_id,
                range: row.range,
                title: row.title,
                description: row.description,
                imagebase64: sec.base64_encode(row.image_p),
                create_at: row.create_at
            });
        }
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
        let row = await db.GetUserImage(req.body.id_user);
        let b64 = sec.base64_encode(row);
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
