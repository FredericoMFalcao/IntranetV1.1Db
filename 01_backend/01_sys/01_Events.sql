-- -------------
--  1. EVENTS
--
--  A table that allows modules to name the events they "export"
-- -------------
CREATE TABLE SYS_Events (
  Name VARCHAR(255),
  Description TEXT,
  OptionsSchema JSON,
  PRIMARY KEY (Name)  
);


