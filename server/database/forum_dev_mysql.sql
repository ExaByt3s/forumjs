DROP DATABASE IF EXISTS forumdev_db;
CREATE DATABASE IF NOT EXISTS forumdev_db;

USE forumdev_db;

CREATE TABLE `accounts` (
    `acc_id`    INT(11) NOT NULL AUTO_INCREMENT,
    `range`     INT(11) NOT NULL,
    `nickname`  VARCHAR(16) NOT NULL,
    `lastname`  VARCHAR(16) NOT NULL,
    `firstname` VARCHAR(16) NOT NULL,
    `email`     VARCHAR(32) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`acc_id`)
);

CREATE TABLE `profiles` (
    `p_id`      INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `image_p`   VARCHAR(64) NOT NULL,
    PRIMARY KEY (`p_id`)
);

CREATE TABLE `follows` (
    `f_id`      INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `cnt_id`    INT(11) NOT NULL,
    PRIMARY KEY (`f_id`)
);

CREATE TABLE `login` (
    `l_id`      INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `password`  VARCHAR(128) NOT NULL,
    `token`     VARCHAR(128) NOT NULL,
    `lastlog`   TIMESTAMP NOT NULL,
    PRIMARY KEY (`l_id`)
);

CREATE TABLE `articles` (
    `ar_id`         INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`         INT(11) NOT NULL,
    `range`         INT(11) NOT NULL,
    `title`         VARCHAR(128) NOT NULL,
    `description`   TEXT,
    `image_p`       VARCHAR(256),
    `create_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ar_id`)
);

CREATE TABLE `likes` (
    `li_id`     INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `ar_id`     INT(11) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`li_id`)
);

CREATE TABLE `unotify` (
    `unt_id`    INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `type`      INT(11) NOT NULL,
    `info_id`   INT(11) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`unt_id`)
);

CREATE TABLE `gnotify` (
    `gnt_id`    INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id`     INT(11) NOT NULL,
    `type`      INT(11) NOT NULL,
    `info_id`   INT(11) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`gnt_id`)
);

CREATE TABLE `pmessage` (
    `pm_id`         INT(11)     NOT NULL AUTO_INCREMENT,
    `sender_id`     INT(11)     NOT NULL,
    `receive_id`    INT(11)     NOT NULL,
    `status`        INT(11)     NOT NULL,
    `subject`       VARCHAR(32) NOT NULL,
    `content`       TEXT        NOT NULL,
    `adjunts`       TEXT,       
    `create_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`pm_id`)
);

ALTER TABLE `profiles`
    ADD CONSTRAINT FK_profiles_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `follows`
    ADD CONSTRAINT FK_follows_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `login`
    ADD CONSTRAINT FK_login_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `articles`
    ADD CONSTRAINT FK_articles_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `likes`
    ADD CONSTRAINT FK_likes_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `unotify`
    ADD CONSTRAINT FK_unotify_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE `gnotify`
    ADD CONSTRAINT FK_gnotify_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
