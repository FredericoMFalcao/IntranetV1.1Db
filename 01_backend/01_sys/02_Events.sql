-- -------------
--  2. EVENTS
--
--  A table that allows modules to name the events they "export"
-- -------------
CREATE TABLE SYS_Events (
  Name VARCHAR(255),
  PRIMARY KEY (Name)  
);


INSERT INTO SYS_Events (Name) VALUES ('willCreateNewFile');
INSERT INTO SYS_Events (Name) VALUES ('didCreateNewFile');
