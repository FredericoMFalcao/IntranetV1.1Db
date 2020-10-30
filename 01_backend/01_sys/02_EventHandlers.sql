-- -------------
--  2. EVENT HANDLERS
--
--  A table that allows modules to "listen and react" to events exported by other modules
-- -------------
CREATE TABLE SYS_EventHandlers (
  EventName VARCHAR(255) NOT NULL,
  BeforeStoredProcedure VARCHAR(255),
  AfterStoredProcedure VARCHAR(255),
  FOREIGN KEY (EventName) REFERENCES SYS_Events(Name)
);

<?php foreach(["Before", "After"] as $Priority) : ?>
DROP PROCEDURE IF EXISTS SYS_Trigger<?=$Priority?>Event;
DELIMITER //
CREATE PROCEDURE SYS_Trigger<?=$Priority?>Event (
  IN in_EventName VARCHAR(255), 
  IN in_Options   JSON
  )
BEGIN
    DECLARE i,j INT; -- counter needed to trigger MANY (not single) events
    DECLARE funcName, sqlCode TEXT; -- variables for the dynamic query code
	  SET i = 0; -- set counter to zero

    -- calculate total number of "listening functions"
	  SET j = (SELECT COUNT(<?=$Priority?>StoredProcedure) FROM SYS_EventHandlers WHERE EventName = in_EventName AND <?=$Priority?>StoredProcedure IS NOT NULL);
	  WHILE i != j DO
      -- store current procedure name into variable: funcName
	    SELECT a.<?=$Priority?>StoredProcedure INTO funcName FROM SYS_EventHandlers a WHERE EventName = in_EventName AND a.<?=$Priority?>StoredProcedure IS NOT NULL LIMIT i,1;

	    -- Call funcName()
--	    SET sqlCode = CONCAT('CALL ',funcName,'(?)'); PREPARE stmt1 FROM sqlCode; EXECUTE stmt1 USING in_Options; DEALLOCATE PREPARE stmt1; 
	    INSERT INTO SYS_EventBacklog (EventName, ListenerName,Type, Data) VALUES (in_EventName,funcName,'<?=$Priority?>',in_Options);
	    
	    SET i = i + 1; -- increment counter
	  END WHILE;
    
END;
//  
DELIMITER ;
<?php endforeach; ?>
