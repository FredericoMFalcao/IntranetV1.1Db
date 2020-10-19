-- Platform Graphical User Interface (GUI) External Javascript and CSS functions
-- Description: Automatically includes External CSS and JS files from 3rd party libs

CREATE TABLE PLT_GUI_ExternalLib (
         _id                        int(11) NOT NULL AUTO_INCREMENT,
        Active                      BOOLEAN DEFAULT(1),
        Comment                     TEXT,
        Type                        ENUM('Javascript','CSS') NOT NULL,
        Url                         TEXT NOT NULL,
        DownloadAndServeLocally     BOOLEAN DEFAULT(1),
        Cache                       TEXT,
         PRIMARY KEY (_id)
);

-- ----------------------
--  SAMPLE CONTENT 
-- ----------------------
INSERT INTO PLT_GUI_ExternalLib (Comment, Type, Url) VALUES ('jQuery Code, useful to write easier to read DOM javascript', 'Javascript', 'https://code.jquery.com/jquery-3.5.1.slim.min.js');
INSERT INTO PLT_GUI_ExternalLib (Comment, Type, Url) VALUES ('necessary for Bootstrap CSS', 'Javascript', 'https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js');
INSERT INTO PLT_GUI_ExternalLib (Comment, Type, Url) VALUES ('main Bootstrap CSS javascript module', 'Javascript', 'https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js');

INSERT INTO PLT_GUI_ExternalLib (Active, Comment, Type, Url) VALUES (0,'Bootstrap javascript module with combo code, NOT WORKING', 'Javascript', 'https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js');

INSERT INTO PLT_GUI_ExternalLib (Comment, Type, Url) VALUES ('main Bootstrap CSS stylesheet','CSS', 'https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css');
