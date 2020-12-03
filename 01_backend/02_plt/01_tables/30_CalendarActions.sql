-- Table: CalendarActions
-- Description: Performs one-off or regular actions
--              described in SQL code or PHP code
--              1. SQL code is executes with admin priviliges
--              2. PHP code doesn't need the start tag "< ? php"

CREATE TABLE <?=tableNameWithModule()?> (
   id                     INT PRIMARY KEY AUTO_INCREMENT,

-- NAME: human readable useful for debuggig only
   Name                   VARCHAR(255) NOT NULL,

-- ACTIVE: boolean (true/false) bit useful for already performed actions, report status
   Active                 INT DEFAULT(1),
   LastActionDate         DATE,
   NextActionDate         DATE NOT NULL,
   RepeatEveryNSeconds    INT,
   SqlCode                TEXT,
   PhpCode                TEXT,
   Log                    TEXT

);
