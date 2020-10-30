-- -------------
--  3. EVENT BACKLOG
--
--  A table that contains the events pending (before they are executed) AND 
--  the events DONE (after they are executed) with a log message useful when they fail
-- -------------
CREATE TABLE SYS_EventBacklog (
  Id INT PRIMARY KEY AUTO_INCREMENT,
  EventName VARCHAR(255) NOT NULL,
  ListenerName VARCHAR(255) NOT NULL,
  Type ENUM('Before','After') NOT NULL,
  Data JSON,
  DateTime TIMESTAMP,
  Status ENUM('Pending', 'Running', 'Done') DEFAULT('Pending'),
  Log TEXT,
  FOREIGN KEY (EventName) REFERENCES SYS_Events(Name)
);
