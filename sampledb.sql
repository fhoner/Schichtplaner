-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Erstellungszeit: 18. Mrz 2017 um 16:32
-- Server-Version: 5.5.42
-- PHP-Version: 7.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Datenbank: `planer`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_email_pending`
--

CREATE TABLE `planer_email_pending` (
  `historyId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_email_subscriber`
--

CREATE TABLE `planer_email_subscriber` (
  `email` varchar(150) NOT NULL,
  `plan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_plan`
--

CREATE TABLE `planer_plan` (
  `name` varchar(100) NOT NULL,
  `public` datetime DEFAULT NULL,
  `editable` datetime DEFAULT NULL,
  `position` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_plan`
--

INSERT INTO `planer_plan` (`name`, `public`, `editable`, `created`, `deleted`) VALUES
('Donnerstag', '2020-01-20 16:00:00', '2030-01-20 16:00:00', '2016-01-20 23:00:00', 0),
('Mittwoch', '2020-02-20 20:00:00', '2020-02-20 20:00:00', '2016-01-23 14:52:40', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_production`
--

CREATE TABLE `planer_production` (
  `name` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `masterName` varchar(100) DEFAULT NULL,
  `masterEmail` varchar(100) DEFAULT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_production`
--

INSERT INTO `planer_production` (`name`, `plan`, `masterName`, `masterEmail`, `position`) VALUES
('Bar', 'Donnerstag', NULL, NULL, 10),
('Bier', 'Donnerstag', NULL, NULL, 0),
('Bier', 'Mittwoch', 'Dominik Honer', 'dhoner@web.de', 0),
('Eingang', 'Mittwoch', NULL, NULL, 0),
('Essen', 'Donnerstag', NULL, NULL, 4),
('Geschirr-Mobil', 'Mittwoch', NULL, NULL, 0),
('Geschirrmobil', 'Donnerstag', NULL, NULL, 3),
('Kaffee/Kuchen', 'Donnerstag', NULL, NULL, 6),
('Kasse', 'Donnerstag', NULL, NULL, 0),
('Kasse', 'Mittwoch', 'Thorsten Marohn', 'tmarohn@gmx.de', 0),
('Pommes', 'Donnerstag', NULL, NULL, 0),
('Pommes', 'Mittwoch', NULL, NULL, 0),
('Steak / Rote', 'Donnerstag', NULL, NULL, 1),
('Steak / Rote', 'Mittwoch', NULL, NULL, 0),
('Wein / Alkfrei', 'Donnerstag', NULL, NULL, 2),
('Wein / Alkfrei', 'Mittwoch', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_production_shift`
--

CREATE TABLE `planer_production_shift` (
  `production` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `required` int(11) NOT NULL DEFAULT '2',
  `comment` varchar(10000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_production_shift`
--

INSERT INTO `planer_production_shift` (`production`, `shift`, `plan`, `required`) VALUES
('Bar', 5, 'Donnerstag', 4),
('Bar', 6, 'Donnerstag', 8),
('Bar', 7, 'Donnerstag', 2),
('Bier', 1, 'Donnerstag', 4),
('Bier', 2, 'Donnerstag', 5),
('Bier', 3, 'Donnerstag', 4),
('Bier', 18, 'Mittwoch', 4),
('Eingang', 18, 'Mittwoch', 2),
('Essen', 9, 'Donnerstag', 4),
('Essen', 10, 'Donnerstag', 1),
('Geschirr-Mobil', 18, 'Mittwoch', 2),
('Geschirrmobil', 1, 'Donnerstag', 3),
('Geschirrmobil', 2, 'Donnerstag', 3),
('Geschirrmobil', 3, 'Donnerstag', 3),
('Kaffee/Kuchen', 8, 'Donnerstag', 4),
('Kasse', 1, 'Donnerstag', 4),
('Kasse', 2, 'Donnerstag', 4),
('Kasse', 3, 'Donnerstag', 4),
('Kasse', 18, 'Mittwoch', 4),
('Pommes', 1, 'Donnerstag', 3),
('Pommes', 2, 'Donnerstag', 3),
('Pommes', 3, 'Donnerstag', 3),
('Pommes', 18, 'Mittwoch', 2),
('Steak / Rote', 1, 'Donnerstag', 4),
('Steak / Rote', 2, 'Donnerstag', 4),
('Steak / Rote', 3, 'Donnerstag', 3),
('Steak / Rote', 18, 'Mittwoch', 4),
('Wein / Alkfrei', 1, 'Donnerstag', 2),
('Wein / Alkfrei', 2, 'Donnerstag', 3),
('Wein / Alkfrei', 3, 'Donnerstag', 2),
('Wein / Alkfrei', 18, 'Mittwoch', 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_shift`
--

CREATE TABLE `planer_shift` (
  `shiftId` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `fromDate` time NOT NULL,
  `toDate` time NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_shift`
--

INSERT INTO `planer_shift` (`shiftId`, `plan`, `fromDate`, `toDate`) VALUES
(1, 'Donnerstag', '09:30:00', '14:00:00'),
(9, 'Donnerstag', '10:30:00', '15:00:00'),
(8, 'Donnerstag', '12:00:00', '17:00:00'),
(5, 'Donnerstag', '12:00:00', '17:30:00'),
(2, 'Donnerstag', '14:00:00', '18:30:00'),
(10, 'Donnerstag', '15:00:00', '16:00:00'),
(7, 'Donnerstag', '16:00:00', '20:30:00'),
(6, 'Donnerstag', '17:30:00', '23:45:00'),
(3, 'Donnerstag', '18:30:00', '23:45:00'),
(18, 'Mittwoch', '17:30:00', '23:00:00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_worker`
--

CREATE TABLE `planer_worker` (
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `production` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `isFixed` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_worker`
--

INSERT INTO `planer_worker` (`name`, `email`, `production`, `plan`, `shift`) VALUES
('Moritz Mauch', 'asd2@asd.de', 'Bier', 'Mittwoch', 18),
('Peter Pressel', 'asd@asd.de', 'Bier', 'Mittwoch', 18);

--
-- Trigger `planer_worker`
--
DELIMITER $$
CREATE TRIGGER `Worker_History_Delete` AFTER DELETE ON `planer_worker`
 FOR EACH ROW INSERT INTO planer_worker_history 
    (nameBefore, 
         nameAfter, 
         emailBefore,
         emailAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (old.name,
         null,
         old.email,
         null,
         old.production,
         old.plan,
         old.shift,
         'delete')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Worker_History_Insert` AFTER INSERT ON `planer_worker`
 FOR EACH ROW INSERT INTO planer_worker_history 
    (nameBefore, 
         nameAfter, 
         emailBefore,
         emailAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (null,
         new.name,
         null,
         new.email,
         new.production,
         new.plan,
         new.shift,
         'insert')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Worker_History_Update` AFTER UPDATE ON `planer_worker`
 FOR EACH ROW IF NEW.name != OLD.name OR
  NEW.email != OLD.email
THEN
INSERT INTO planer_worker_history 
    (nameBefore, 
         nameAfter, 
         emailBefore,
         emailAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (old.name,
         new.name,
         old.email,
         new.email,
         new.production,
         new.plan,
         new.shift,
         'update');
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_worker_history`
--

CREATE TABLE `planer_worker_history` (
  `historyId` int(11) NOT NULL,
  `nameBefore` varchar(100) DEFAULT NULL,
  `nameAfter` varchar(100) DEFAULT NULL,
  `emailBefore` varchar(100) DEFAULT NULL,
  `emailAfter` varchar(100) DEFAULT NULL,
  `production` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `action` varchar(25) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=latin1;

--
-- Trigger `planer_worker_history`
--
DELIMITER $$
CREATE TRIGGER `Insert_Email_Pending` AFTER INSERT ON `planer_worker_history`
 FOR EACH ROW INSERT INTO planer_email_pending (historyId) VALUES (new.historyId)
$$
DELIMITER ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `planer_email_pending`
--
ALTER TABLE `planer_email_pending`
  ADD PRIMARY KEY (`historyId`);

--
-- Indizes für die Tabelle `planer_email_subscriber`
--
ALTER TABLE `planer_email_subscriber`
  ADD PRIMARY KEY (`email`,`plan`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `planer_plan`
--
ALTER TABLE `planer_plan`
  ADD PRIMARY KEY (`name`);

--
-- Indizes für die Tabelle `planer_production`
--
ALTER TABLE `planer_production`
  ADD PRIMARY KEY (`name`,`plan`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `planer_production_shift`
--
ALTER TABLE `planer_production_shift`
  ADD PRIMARY KEY (`production`,`shift`),
  ADD KEY `fk_prodshift_shift_idx` (`shift`),
  ADD KEY `plan` (`plan`),
  ADD KEY `fk_prodshift_production` (`production`,`plan`);

--
-- Indizes für die Tabelle `planer_shift`
--
ALTER TABLE `planer_shift`
  ADD PRIMARY KEY (`shiftId`),
  ADD UNIQUE KEY `plan_2` (`plan`,`fromDate`,`toDate`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `planer_worker`
--
ALTER TABLE `planer_worker`
  ADD PRIMARY KEY (`name`,`shift`),
  ADD KEY `shift` (`shift`),
  ADD KEY `fk_worker_production_idx` (`production`),
  ADD KEY `plan` (`plan`),
  ADD KEY `fk_worker_production` (`production`,`plan`);

--
-- Indizes für die Tabelle `planer_worker_history`
--
ALTER TABLE `planer_worker_history`
  ADD PRIMARY KEY (`historyId`),
  ADD KEY `emailAfter` (`emailAfter`),
  ADD KEY `production` (`production`),
  ADD KEY `shift` (`shift`),
  ADD KEY `production_2` (`production`),
  ADD KEY `plan` (`plan`),
  ADD KEY `fk_whistory_production` (`production`,`plan`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `planer_shift`
--
ALTER TABLE `planer_shift`
  MODIFY `shiftId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT für Tabelle `planer_worker_history`
--
ALTER TABLE `planer_worker_history`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=62;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `planer_email_pending`
--
ALTER TABLE `planer_email_pending`
  ADD CONSTRAINT `planer_email_pending_ibfk_1` FOREIGN KEY (`historyId`) REFERENCES `planer_worker_history` (`historyId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_email_subscriber`
--
ALTER TABLE `planer_email_subscriber`
  ADD CONSTRAINT `planer_email_subscriber_ibfk_1` FOREIGN KEY (`plan`) REFERENCES `planer_plan` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_production`
--
ALTER TABLE `planer_production`
  ADD CONSTRAINT `fk_production_plan` FOREIGN KEY (`plan`) REFERENCES `planer_plan` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_production_shift`
--
ALTER TABLE `planer_production_shift`
  ADD CONSTRAINT `fk_prodshift_production` FOREIGN KEY (`production`, `plan`) REFERENCES `planer_production` (`name`, `plan`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prodshift_shift` FOREIGN KEY (`shift`) REFERENCES `planer_shift` (`shiftId`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_shift`
--
ALTER TABLE `planer_shift`
  ADD CONSTRAINT `fk_shift_plan` FOREIGN KEY (`plan`) REFERENCES `planer_plan` (`name`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_worker`
--
ALTER TABLE `planer_worker`
  ADD CONSTRAINT `fk_worker_production` FOREIGN KEY (`production`, `plan`) REFERENCES `planer_production` (`name`, `plan`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_worker_shift` FOREIGN KEY (`shift`) REFERENCES `planer_shift` (`shiftId`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `planer_worker_history`
--
ALTER TABLE `planer_worker_history`
  ADD CONSTRAINT `fk_whistory_shift` FOREIGN KEY (`shift`) REFERENCES `planer_shift` (`shiftId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_whistory_production` FOREIGN KEY (`production`, `plan`) REFERENCES `planer_production` (`name`, `plan`) ON DELETE CASCADE ON UPDATE CASCADE;
