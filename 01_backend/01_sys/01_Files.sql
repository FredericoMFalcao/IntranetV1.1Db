CREATE TABLE SYS_Files (
  -- Id is the MD5 sum of the contents of the file
  --    as produced by "md5sum" on ubuntu
  Id CHAR(32),
  MimeType VARCHAR(255) DEFAULT ("text/plain"),
  DateCreated TIMESTAMP,
  PRIMARY KEY (Id)  
);
