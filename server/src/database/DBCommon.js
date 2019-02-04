const mysql = require('promise-mysql');
const config_db = require('./db_config');
const util = require('../lib/utilities');
const { PersonalException } = require('../lib/exception_handler');
const srt = require('../lib/secure_utils');

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
            let pass_encrypt = srt.mkHashSHA512(args[1]);
            query = "SELECT `ac_id` FROM `login` WHERE `password` = '" + pass_encrypt + "' AND `ac_id` = " + rows[0].acc_id + ";";
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
            [-0-] = range         1 = user, 2 = moderator, 3 = advertise, 4 = developer, 5 = administrator, 6 = owned
            [0] = nickname
            [1] = lastname
            [2] = firstname
            [3] = email
            [4] = password      hash 512 (128 length)
            [5] = path_img
         */
        try {
            // check user existen
            if (!((await this.GetUserIdByEmail(args[3], true)) == -1) || 
                !((await this.GetUserIdByNickname(args[0], true)) == -1)) {
                throw new PersonalException(`User or Email exists`, 'RegisterUser', '-7');
            }

            let query = "INSERT INTO `accounts`(`range`,`nickname`,`lastname`,`firstname`,`email`) " + 
                        `VALUES(${1}, '${args[0]}','${args[1]}','${args[2]}','${args[3]}');`;
        
            await this.ExecQry(query);

            // Add password login.
            let id = await this.GetUserIdByEmail(args[3]);
            let token = srt.GenerateToken(id);
            let pass_encrypt = srt.mkHashSHA512(args[4]);
            query = "INSERT INTO `login`(`ac_id`,`password`,`token`,`lastlog`) " +
                    `VALUES(${id},'${pass_encrypt}','${token}','${util.DateToMysqlFormat()}');`;
        
            await this.ExecQry(query);

            // Add profile photo.
            query = "INSERT INTO `profiles`(`ac_id`,`image_p`) " +
                    `VALUES(${id},'${args[5]}');`;
            await this.ExecQry(query);

            return true;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.error(err);
                return false;
            }
            throw err;
        }
    }

    // articles
    async PushArticle(args) {
        /* Args
            [0] = account id
            [1] = range         1 = user, 2 = moderator, 3 = advertise, 4 = developer, 5 = administrator, 6 = owned
            [2] = title
            [3] = description
            [4] = image_p
         */
        try {
            let query = "INSERT INTO `articles`(`ac_id`,`range`,`title`,`description`,`image_p`) " +
                    `VALUES(${args[0]},${args[1]},'${args[2]}','${args[3]}','${args[4]}');`;
            
            await this.ExecQry(query);
            return true;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.error(err);
                return false;
            }
            throw err;
        }
    }

    // Global Notifications
    async InternalPushGNotification(args) {
        /* Args
            [0] = ac_id
            [1] = type          0 = new article
            [2] = info_id
        */
        try {
            let query = "INSERT INTO `gnotify`(`ac_id`,`type`,`info_id`) " +
                    `VALUES(${args[0]},${args[1]},${args[2]})`;
            await this.ExecQry(query);
            return true;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.error(err);
                return false;
            }
            return err;
        }
    }

    // User Notifications
    async InternalPushUNotification(args) {
        /* Args
            [0] = account id
            [1] = type          0 = new article | 1 = private message
            [2] = info_id
        */
        try {
            let query = "INSERT INTO `unotify`(`ac_id`,`type`,`info_id`) " +
                    `VALUES(${args[0]},${args[1]},${args[2]});`;
            await this.ExecQry(query);
            return true;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.error(err);
                return false;
            }
            throw err;
        }
    }

    async ConfirmUserNotification(id, nt_id) {
        try {
            if (!id || !nt_id) throw "known't";
            let query = "DELETE FROM `unotify` WHERE `unt_id`="+nt_id+" AND `ac_id`="+id+";";
            let result = await this.ExecQry(query);
            console.log(result);
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "known't";
            }
            throw err;
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
            let rows = await this.ExecQry("SELECT * FROM `accounts` WHERE `acc_id`="+id+";");
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
            let rows = await this.ExecQry("SELECT `token` FROM `login` WHERE `ac_id`="+id+";");
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

    async GetUserIdByEmail(email, for_checked) {
        try {
            if (!email) throw "know't";
            let rows = await this.ExecQry("SELECT `acc_id` FROM `accounts` WHERE `email` ='"+email+"';");
            if (!rows.length) {
                if (!for_checked)
                    throw new PersonalException(`Not found id in this email: ${email}.`, 'GetUserIdByEmail', '-2');
                else
                    return -1; // no existe
            } else {
                return rows[0].acc_id;
            }
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetUserIdByNickname(nickname, for_checked) {
        try {
            if (!nickname) throw "know't"
            let rows = await this.ExecQry("SELECT `acc_id` FROM `accounts` WHERE `nickname` ='"+nickname+"';");
            if (!rows.length) {
                if (!for_checked)
                    throw new PersonalException(`Not found id in this nickname: ${nickname}.`, 'GetUserIdByNickname', '-2');
                else
                    return -1;  // no existe
            } else {
                return rows[0].acc_id;
            }
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetUserImage(id) {
        try {
            if (!id) throw "know't No hay id";
            let rows = await this.ExecQry("SELECT `image_p` FROM `profiles` WHERE `ac_id`="+id+";");
            if (!rows.length) {
                throw new PersonalException(`Not found image`, 'GetUserImage', -11);
            } else {
                return rows[0].image_p;
            }
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.error(err);
                throw "know't";
            }
            throw err;
        }
    }

    // Gets for Articles
    async GetArticles(offset) {
        try {
            //if (!offset) throw "know't";
           // let rows = await this.ExecQry("SELECT * FROM `article` WHERE `ar_id` < " + offset + 
           //                                 " ORDER BY `li_id` DESC;");
            let rows = await this.ExecQry("SELECT `ar_id`, `ac_id` FROM `articles`;");
            if (!rows.length)
                throw new PersonalException(`Empty articles.`, 'GetArticles', '-10');
            return rows;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetArticleById(id_article) {
        try {
            if (!id_article) throw "know't";
            let rows = await this.ExecQry("SELECT * FROM `articles` WHERE `ar_id` ="+id_article+";");
            if (!rows.length)
                throw new PersonalException(`Not found article id: ${id_article}.`, 'GetArticle', '-8');
            return rows[0];
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                console.log(err);
                throw "know't";
            }
            throw err;
        }
    }

    async GetArticleLikes(id_article) {
        try {
            if (!id_article) throw "know't";
            let rows = await this.ExecQry("SELECT * FROM `likes` WHERE `ar_id`="+id_article+";");
            if (!rows.length)
                throw new PersonalException(`Not found article id: ${id_article}.`, 'GetArticle', '-9');
            return rows.length;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetLastArticleByOwner(id_usr) {
        try {
            if (!id_usr) throw "known't";
            let rows = await this.ExecQry("SELECT `gnt_id` FROM `gnotify` WHERE `ac_id`="+id_usr+
                                          " ORDER BY `gnt_id` DESC LIMIT 1;");
            if (!rows.length)
                throw new PersonalException(`Empty articles.`, 'GetArticles', '-10');
            return rows[0];
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "known't";
            }
            throw err;
        }
    }

    // Get for Notifications
    async GetUserNotifications(id_user, offset) {
        try {
            if (!id_user) throw "know't";
            let rows = await this.ExecQry("SELECT * FROM `unotify` WHERE `ac_id`="+id_user+";");
            if (!rows.length)
                throw new PersonalException(`Not found unotify id: ${id_user}.`, 'GetNotifications', '-12');
            return rows;
        } catch (err) {
            if (!(err instanceof PersonalException)) {
                throw "know't";
            }
            throw err;
        }
    }

    async GetGlobalNotifications(offset) {
        try {
            if (!id_user || !offset) throw "know't";
            let rows = await this.ExecQry("SELECT * FROM `gnotify` WHERE `gnt_id` > "+offset+";");
            if (!rows.length)
                throw new PersonalException(`Not found unotify id: ${id_user}.`, 'GetNotifications', '-12');
            return rows;
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
            let new_token = srt.GenerateToken(id);
            let rows = await this.ExecQry("UPDATE `login` SET `token`='"+ new_token+ 
                                          "' WHERE `ac_id`="+id+";");
            if (!rows.affectedRows)
                throw new PersonalException(`Data in the not found.`,'UpdateUserToken','-2')
            return new_token;
        } catch (err) {
            if(!(err instanceof PersonalException)) {
                console.error(err + 'checkeando');
                throw "know't";
            }
            throw err;
        }
    }

    // on dev
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
