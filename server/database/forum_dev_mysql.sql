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

ALTER TABLE `login`
    ADD CONSTRAINT FK_login_accounts FOREIGN KEY (`ac_id`)
        REFERENCES `accounts`(`acc_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
