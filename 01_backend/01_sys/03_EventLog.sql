-- -------------
--  3. EVENT HANDLERS
--
--  A table that contains the log of all events triggered
-- -------------
CREATE TABLE SYS_EventLog (
  EventName VARCHAR(255) NOT NULL,
  DateTime TIMESTAMP,
  FOREIGN KEY (EventName) REFERENCES SYS_Events(Name)
);
