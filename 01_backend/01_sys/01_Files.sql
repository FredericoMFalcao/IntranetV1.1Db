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
--  2. C.U.D. Operations (with Events)
--
-- ----------------

-- 2.1 Insert (with Events)
DELIMITER //
CREATE PROCEDURE FilesNew(Id CHAR(32), MimeType VARCHAR(255))
BEGIN
  
  DECLARE i, j INT;
  DECLARE funcName, sqlCode TEXT;
                                                               
  -- 2.1.1 Call BEFORE triggers
  -- ---------------------------                                                               
  SET i = 0; -- set counter to zero
  -- calculate total number of "listening functions"
  SET j = (SELECT COUNT(BeforeStoredProcedure) FROM SYS_EventHandlers WHERE EventName = "NewFile");
  WHILE i != j DO
    SELECT a.BeforeStoredProcedure INTO funcName FROM SYS_EventHandlers a LIMIT i,1;

    -- Call funcName()
    SET sqlCode = CONCAT('CALL ',funcName,'()'); PREPARE stmt1 FROM sqlCode; EXECUTE stmt1;

    SET i = i + 1;
  END WHILE;

                                                               
                                                               
  -- 2.1.2 Perform operation
  -- ---------------------------
  INSERT INTO SYS_Files (Id, MimeType) VALUES (Id, MimeType);
                                                               
  -- 2.1.3 Call AFTER triggers
  -- ---------------------------
                                                               

END;
//

DELIMITER ;
