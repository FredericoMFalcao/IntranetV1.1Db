-- ---------------------------
--   ASYNC_EVENT_LOOP
--
--   Description: a stored procedure that is called every 2 seconds
--
--        1. checks for pending events
--        2. executes them with the data provided
--        3. marks them as DONE or FAILED
-- ---------------------------


DELIMITER //
CREATE EVENT `ASYNC_EVENT_LOOP` ON SCHEDULE EVERY 2 SECOND 
ON COMPLETION NOT PRESERVE ENABLE DO 
BEGIN

DECLARE v_Data JSON;
DECLARE v_funcName, v_sqlCode TEXT;
DECLARE v_Id INT;

-- 3.1 Setup Sandbox (catch errors/exceptions )
--   (n.b. MariaDB needs this handler to be declared HERE)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
        UPDATE SYS_EventBacklog SET Status = 'Failed', Log = @p2 WHERE Id = v_Id;
    END;



-- 1. Load Event to be executed
--
--  execute the BEFOREs first, then the PROCESSINGs, then the AFTERs
--  so that everything is execute in a correct tree-like depth first fashion
SELECT 
Id, ListenerName, Data INTO v_Id, v_funcName, v_Data
FROM SYS_EventBacklog AS a
WHERE Status = 'Pending'
ORDER BY (CASE WHEN Type = "Before" THEN 1 WHEN Type = "Processing" THEN 2 WHEN Type = "After" THEN 3 END) ASC
LIMIT 1;

-- 2. Update status of Event to DONE
UPDATE SYS_EventBacklog SET Status = 'Running' WHERE Id = v_Id;


-- 3. Execute Event

-- 3.2 TRY to execute
SET v_sqlCode = CONCAT('CALL ',v_funcName,'(?)'); PREPARE stmt1 FROM v_sqlCode; EXECUTE stmt1 USING v_Data; DEALLOCATE PREPARE stmt1;

-- 4. Update status of Event to DONE
UPDATE SYS_EventBacklog SET Status = 'Done' WHERE Id = v_Id AND Status = 'Running';


END;
//
DELIMITER ;


-- @TODO: build sys needs permission to run this
--        error: ... at line 227: Access denied; you need (at least one of) the SUPER privilege(s) for this operation
-- SET GLOBAL event_scheduler = ON;
