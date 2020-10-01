-- Table: Types
-- Description: List all the system-wide types and an i/o function in every supported environment

CREATE TABLE <?=tableNameWithModule()?> (
  Name VARCHAR(255) NOT NULL, -- e.g. text, number, etc...

 lastUpdated timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 JS_Render_FormField text NOT NULL,
 JS_GetFrom_FormField text NOT NULL DEFAULT '',
 JS_SetTo_FormField text NOT NULL DEFAULT '',
 JS_Render_TableData text NOT NULL,
 JS_Render_Filter text NOT NULL,
 JS_GetStateOfFormField text NOT NULL,
 PHP_Render_LaTeX_Report text NOT NULL,
 DependsOn varchar(255) DEFAULT NULL,

PRIMARY KEY (Name),

FOREIGN KEY (DependsOn) REFERENCES <?=tableNameWithModule()?> (Name)
);
