-- Virtual Tables
-- Description: (1) this table will list all the REST available endpoints
--                    - that are technically virtual tables (a combination of stored procedures for input / views for output)
--              (2) allows client/browser to query data with "metadata"
--                    - metadata helps the browser to know how to auto-build create/edit forms and parse text data into images, icons, etc... 
CREATE TABLE PLT_VirtualTables (
  Name VARCHAR(255) NOT NULL,
  PrimaryKey JSON,
  PRIMARY KEY (Name)
   
);

CREATE TABLE PLT_VirtualTablesFields (
  ParentTable VARCHAR(255), -- foreign key
  Name VARCHAR(255) NOT NULL,
  Type VARCHAR(25) NOT NULL,
  FOREIGN KEY (ParentTable) REFERENCES PLT_VirtualTables(Name) ON UPDATE CASCADE ON DELETE CASCADE
);


-- -- INITIAL DATA ----
INSERT INTO PLT_VirtualTables (Name, PrimaryKey) VALUES ('PorClassificarFornecedor','["NumSerie"]');
INSERT INTO PLT_VirtualTablesFields (ParentTable, Name, Type) VALUES ('PorClassificarFornecedor','NumSerie','TEXT');

INSERT INTO PLT_VirtualTables (Name, PrimaryKey) VALUES ('PorClassificarAnalitica','["NumSerie"]');
INSERT INTO PLT_VirtualTablesFields (ParentTable, Name, Type) VALUES ('PorClassificarAnalitica',"NumSerie",'TEXT');
