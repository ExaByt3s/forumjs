--CREATE DATABASE forum_dev;

USE forum_dev;
GO

CREATE TABLE [Accounts] (
    [acc_id]        INT             NOT NULL    IDENTITY,
    [nickname]      VARCHAR(16)     NOT NULL,
    [range]         INT             NOT NULL,   -- user : 1, moderator : 2, dev : 3, owned : 4
    [last_name]     VARCHAR(16)     NOT NULL,
    [first_name]    VARCHAR(16)     NOT NULL,
    [mail]          VARCHAR(32)     NOT NULL,
    [creat_at]      DATE            default     GETDATE(),
    CONSTRAINT PK_Accounts PRIMARY KEY NONCLUSTERED ([acc_id])
); 
GO

CREATE TABLE [Login] (
    [l_id]          INT             NOT NULL    IDENTITY,
    [ac_id]         INT             NOT NULL,
    [password]      VARCHAR(128)    NOT NULL,   -- password encrypter [256] characteres
    [last_log]      DATETIME        NOT NULL,
    [token]			VARCHAR(128)	NOT NULL,
    CONSTRAINT PK_Login PRIMARY KEY NONCLUSTERED ([l_id]),
    CONSTRAINT FK_Accounts_Login FOREIGN KEY ([ac_id])
		REFERENCES Accounts ([acc_id])
		ON DELETE CASCADE
		ON UPDATE CASCADE
); 
GO
