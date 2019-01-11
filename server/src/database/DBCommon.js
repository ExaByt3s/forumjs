const mysql = require('promise-mysql');
const config_db = require('./db_config');
const { GenerateToken, DateToMysqlFormat, PersonalException } = require('./utilities');
const secure = require('./secure_utils');

class DBCommon
{
    constructor() {
        this.conn = null;
        this.Connect();
    }

    async Connect() {
        try {
            this.conn = await mysql.createConnection(config_db);
            console.log(`Database MYSQL is Connected`);
        } catch (err) {
            console.error(err);
        }
    }

    async ExecQry(query) {
        try {
            return await this.conn.query(query);
        } catch (err) {
            console.error(err);
            return await null;
        }
    }

    // Log In user
    async LoginUser(args) {
        /* Args
                [0] = nickname
                [1] = password
             */ 
        try {
            let query = "SELECT `acc_id` FROM `accounts` WHERE `nickname` = '" + args[0] + "';";
            let rows = await this.ExecQry(query);
            if (!rows.length)
                throw new PersonalException(``, '', '');
            let pass_encrypt = secure.mkHashSHA512(args[1]);
            query = "SELECT `ac_id` FROM `login` WHERE `password` = '" + pass_encrypt + "';";
            rows = await this.ExecQry(query);
            if (!rows.length)
                throw new PersonalException(``, '', '');
            return rows[0].ac_id;
        } catch (err) {
            if (err instanceof PersonalException) {
                throw new PersonalException(`Data incorrect`, 'LoginUser', '-6');
            }
        }
    }

    // register
    async RegisterUser(args) {
        /* Args
            [0] = range         1 = user, 2 = moderator, 3 = advertise, 4 = developer, 5 = administrator, 6 = owned
            [1] = nickname
            [2] = lastname
            [3] = firstname
            [4] = email
            [5] = password      hash 512 (128 length)
         */
        try {
            let query = "INSERT INTO `accounts`(`range`,`nickname`,`lastname`,`firstname`,`email`) " + 
                    "VALUES(" + args[0] + ",'" +
                                args[1] + "','" +
                                args[2] + "','" + 
                                args[3] + "','" +
                                args[4] + "');";
        
            await this.ExecQry(query);

            let id = await this.GetUserIdByEmail(args[4]);
            let token = GenerateToken(id);
            let pass_encrypt = secure.mkHashSHA512(args[5]);
            query = "INSERT INTO `login`(`ac_id`,`password`,`token`,`lastlog`) " +
                    "VALUES(" + id + ",'" +
                                pass_encrypt + "','" +
                                token + "','" +
                                DateToMysqlFormat() + "');";
        
            await this.ExecQry(query);
            return true;
        } catch (err) {
            console.error(err);
            return false;
        }
    }

    // Gets
    async GetAllUsers() {
        try {
            let rows = await this.ExecQry("SELECT * FROM `accounts`;");
            if (!rows.length)
                throw new PersonalException(`DB Empty.`, 'GetAllUsers', '-5');
            return rows;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetUserById(id) {
        try {
            if (!id) throw "know't";
            let rows = await this.ExecQry("SELECT * FROM `accounts` WHERE `acc_id` = " + id + ";");
            if (!rows.length)
                throw new PersonalException(`Not found this id: ${id}.`, 'GetUserById', '-2');
            return rows[0]; 
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetTokenUser(id) {
        try {
            if (!id) throw "know't";
            let rows = await this.ExecQry("SELECT `token` FROM `login` WHERE `ac_id` = " + id + ";");
            if (!rows.length)
                throw new PersonalException(`Not found token in this id: ${id}.`, 'GetTokenUser', '-1');
            return rows[0].token;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetUserIdByEmail(email) {
        try {
            if (!email) throw "know't";
            let rows = await this.ExecQry("SELECT `acc_id` FROM `accounts` WHERE `email` = '" + email + "';");
            if (!rows.length)
                throw new PersonalException(`Not found id in this email: ${email}.`, 'GetUserIdByEmail', '-2');
            return rows[0].acc_id;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    // Updates
    async UpdateUserToken(id) {
        try {
            if (!id) throw "know't";
            let new_token = GenerateToken(id);
            let rows = await this.ExecQry("UPDATE `login` SET `token` = '" + new_token + 
                                          "' WHERE `ac_id` = " + id + ";");
            if (!rows.affectedRows)
                throw new PersonalException(`Data in the not found.`,'UpdateUserToken','-2')
            return new_token;
        } catch (err) {
            if(!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    // in dev
    async ClearTables() {
        try {
            await this.ExecQry("DELETE FROM `accounts`;");
            return true;
        } catch (err) {
            console.error(err);
            return false;
        }
    }
}

module.exports = new DBCommon();
