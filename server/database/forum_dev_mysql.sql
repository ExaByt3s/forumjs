DROP DATABASE IF EXISTS forumdev_db;
CREATE DATABASE IF NOT EXISTS forumdev_db;

USE forumdev_db;

CREATE TABLE `accounts` (
    `acc_id` INT(11) NOT NULL AUTO_INCREMENT,
    `range` INT(3) NOT NULL,
    `nickname` VARCHAR(16) NOT NULL,
    `lastname` VARCHAR(16) NOT NULL,
    `firstname` VARCHAR(16) NOT NULL,
    `email` VARCHAR(32) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`acc_id`)
);

CREATE TABLE `login` (
    `l_id` INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id` INT(11) NOT NULL,
    `password` VARCHAR(128) NOT NULL,
    `token` VARCHAR(128) NOT NULL,
    `lastlog` TIMESTAMP NOT NULL,
    PRIMARY KEY (`l_id`)
);

CREATE TABLE `articles` (
    `ar_id` INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id` INT(11) NOT NULL,
    `range` INT(11) NOT NULL,
    `title` VARCHAR(128) NOT NULL,
    `description` TEXT,
    `image_p` VARCHAR(256),
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ar_id`)
);

CREATE TABLE `likes` (
    `li_id` INT(11) NOT NULL AUTO_INCREMENT,
    `ac_id` INT(11) NOT NULL,
    `ar_id` INT(11) NOT NULL,
    `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`li_id`)
);

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
