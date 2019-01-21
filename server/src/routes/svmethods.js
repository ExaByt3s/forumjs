const db = require('../database/DBCommon');
const { PersonalException, checkFieldInJson } = require('../database/utilities');

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
    }
Response:
    {
        codError:
    }
 */
methods.register_user = async (req) => {
    let check = await checkRequestJson(req.body, ['nickname','lastname','firstname','email','password']);
    if (!check[0]) return check[1];
    try {
        let result = await db.RegisterUser([
            req.body.nickname,
            req.body.lastname,
            req.body.firstname,
            req.body.email,
            req.body.password
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
        return { codError: -2 };
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
