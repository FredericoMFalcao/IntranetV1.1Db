-- Virtual Tables
-- Description: (1) this table will list all the REST available endpoints
--                    - that are technically virtual tables (a combination of stored procedures for input / views for output)
--              (2) allows client/browser to query data with "metadata"
--                    - metadata helps the browser to know how to auto-build create/edit forms and parse text data into images, icons, etc... 
CREATE TABLE PLT_VirtualTables (
  Name VARCHAR(255) NOT NULL,
  
  -- SQL CRUD Operations:
  -- Fields that will hold SQL code to perform C.R.U.D. operations on these virtual tables
  -- N.B.: if any of these are NULL, code will be automatically generated during the "build" process based on the table Fields
  SQLCreateStoredProcedure TEXT,
  SQLReadStoredProcedure TEXT,
  SQLUpdateStoredProcedure TEXT,
  SQLDeleteStoredProcedure TEXT,

  -- JS Table, CreateNewForm and EditForm:
  -- Fields that will hold a JS function that produces a DomElement
  -- N.B.: if any of these are NULL, code will be automatically generated during the "build" process based on the table Fields
  JSCreateStoredProcedure TEXT,
  JSReadStoredProcedure TEXT,
  JSUpdateStoredProcedure TEXT,
  JSDeleteStoredProcedure TEXT,

  
  PrimaryKey JSON,
  PRIMARY KEY (Name)
   
);

CREATE TABLE PLT_VirtualTablesFields (
  ParentTable VARCHAR(255), -- foreign key
  Name VARCHAR(255) NOT NULL,
  Type VARCHAR(25) NOT NULL,
  AllowNull INT DEFAULT 0,
  DefaultValue TEXT DEFAULT "",
  Options JSON,
  FOREIGN KEY (ParentTable) REFERENCES PLT_VirtualTables(Name) ON UPDATE CASCADE ON DELETE CASCADE
);


