-- ----------------
--  1. Data Store
--
-- ----------------

CREATE TABLE SYS_Files (
  -- Id is the MD5 sum of the contents of the file
  --    as produced by "md5sum" on ubuntu
  Id CHAR(32),
  MimeType VARCHAR(255) DEFAULT ("text/plain"),
  DateCreated TIMESTAMP,
  PRIMARY KEY (Id)  
);




-- ----------------
--  2. Abstracted C.U.D. Operations
--
--  Description: instead of the normal "insert into" and "update", the other modules should call
--               FilesNew(...), FileEdit(id, ...), FileDelete(id) to "insert", "update", "delete"
--
--               Why? In MySql/MariaDB it is not possible to run "dynamic sql" inside triggers.
--                    Therefore the only way to implement an event triggering "insert"/"update"/"delete" operation
--                    is to abstract these operations into custom "stored procedures"
-- ----------------

-- 2.1 Insert (with Events)
DELIMITER //
CREATE PROCEDURE FilesNew(Id CHAR(32), MimeType VARCHAR(255))
BEGIN
  
  DECLARE i, j INT;
  DECLARE funcName, sqlCode TEXT;
                                                               
  -- 2.1.1 Call BEFORE triggers
  -- ---------------------------                                                               
  CALL SYS_TriggerBeforeEvent("NewFile", JSON_OBJECT("FileId", Id, "MimeType", MimeType));
                                                               
                                                               
  -- 2.1.2 Perform operation
  -- ---------------------------
  INSERT INTO SYS_Files (Id, MimeType) VALUES (Id, MimeType);
                                                               
  -- 2.1.3 Call AFTER triggers
  -- ---------------------------
  CALL SYS_TriggerAfterEvent("NewFile", JSON_OBJECT("FileId", Id, "MimeType", MimeType));                                                            

END;
//
DELIMITER ;


-- ----------------
--  3. Register Exported Events
--	( events that are available for other modules to listen/react to)
-- ----------------
INSERT INTO SYS_Events (Name) VALUES ('NewFile');
