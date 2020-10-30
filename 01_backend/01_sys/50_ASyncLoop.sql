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

-- 1. Load Event to be executed
SELECT 
Id, ListenerName, Data INTO v_Id, v_funcName, v_Data
FROM SYS_EventBacklog AS a
WHERE Status = 'Pending'
LIMIT 1;

-- 2. Update status of Event to DONE
UPDATE SYS_EventBacklog SET Status = 'Running' WHERE Id = v_Id;


-- 3. Execute Event
SET v_sqlCode = CONCAT('CALL ',v_funcName,'(?)'); PREPARE stmt1 FROM v_sqlCode; EXECUTE stmt1 USING v_Data; DEALLOCATE PREPARE stmt1;

-- 4. Update status of Event to DONE
UPDATE SYS_EventBacklog SET Status = 'Done' WHERE Id = v_Id;


END;
//
DELIMITER ;

SET GLOBAL event_scheduler = ON;
