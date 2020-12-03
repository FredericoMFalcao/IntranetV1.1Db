-- Web Sessions
-- Description: stores the users logged in (i.e. with an active session) at the server
--              Useful:
--                      1. If you want to restart the server, and need to know if anyone is using the it
--                      2. Keep track of their requested notifications events
CREATE TABLE PLT_WebSessions (
	Token CHAR(32) PRIMARY KEY,
	IP    CHAR(15),
	LastAccessed DATETIME DEFAULT(NOW()),
	User         VARCHAR(25) NOT NULL,


	-- Note: ListeningToEvents should be type JSON, but MEMORY engine doesn't support it
	ListeningToEvents VARCHAR(1024) DEFAULT('[]')
) ENGINE=memory;


-- Purge Old WebSessions via Calendar Action
INSERT INTO PLT_CalendarActions (Name, NextActionDate, RepeatEveryNSeconds, SqlCode) VALUES ('Purge Old WebSession', NOW(), 60, 'DELETE FROM PLT_WebSessions WHERE LastAccessed < NOW() - INTERVAL 1 DAY');
