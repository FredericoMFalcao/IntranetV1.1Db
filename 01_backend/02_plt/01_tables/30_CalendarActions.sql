-- Table: CalendarActions
-- Description: Performs one-off or regular actions
--              described in SQL code or PHP code
--              1. SQL code is executes with webServer username and priviliges
--                  @todo: create a custom sql username for calendar actions
--              2. PHP code doesn't need the start tag "< ? php"
--                  - executes with "www-data" (apache's user)
--                  - has sql() function available to perform actions on the database

CREATE TABLE <?=tableNameWithModule()?> (
   id                     INT PRIMARY KEY AUTO_INCREMENT,

-- NAME: human readable useful for debuggig only
   Name                   VARCHAR(255) NOT NULL,

-- ACTIVE: boolean (true/false) bit useful for already performed actions, report status
   Active                 INT DEFAULT(1),
   LastActionDate         DATETIME,
   NextActionDate         DATETIME NOT NULL,
   RepeatEveryNSeconds    INT,
   SqlCode                TEXT,
   PhpCode                TEXT,
   Log                    TEXT

);
