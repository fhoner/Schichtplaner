-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Erstellungszeit: 23. Jan 2016 um 18:32
-- Server-Version: 5.5.42
-- PHP-Version: 7.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Datenbank: `schichtplaner`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_email_pending`
--

CREATE TABLE `mvoe_email_pending` (
  `historyId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_email_subscriber`
--

CREATE TABLE `mvoe_email_subscriber` (
  `email` varchar(150) NOT NULL,
  `plan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_email_subscriber`
--

INSERT INTO `mvoe_email_subscriber` (`email`, `plan`) VALUES
('blog@felix-honer.com', 'Mittwoch'),
('privat@felix-honer.com', 'Mittwoch');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_plan`
--

CREATE TABLE `mvoe_plan` (
  `name` varchar(100) NOT NULL,
  `public` datetime DEFAULT NULL,
  `editable` datetime DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_plan`
--

INSERT INTO `mvoe_plan` (`name`, `public`, `editable`, `created`, `deleted`) VALUES
('Donnerstag', '2020-01-20 16:00:00', '2030-01-20 16:00:00', '2016-01-20 23:00:00', 0),
('Mittwoch', '2020-02-20 20:00:00', '2020-02-20 20:00:00', '2016-01-23 14:52:40', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_production`
--

CREATE TABLE `mvoe_production` (
  `name` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `masterName` varchar(100) DEFAULT NULL,
  `masterEmail` varchar(100) DEFAULT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_production`
--

INSERT INTO `mvoe_production` (`name`, `plan`, `masterName`, `masterEmail`, `position`) VALUES
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
-- Tabellenstruktur für Tabelle `mvoe_production_shift`
--

CREATE TABLE `mvoe_production_shift` (
  `production` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `required` int(11) NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_production_shift`
--

INSERT INTO `mvoe_production_shift` (`production`, `shift`, `plan`, `required`) VALUES
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
-- Tabellenstruktur für Tabelle `mvoe_shift`
--

CREATE TABLE `mvoe_shift` (
  `shiftId` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `fromDate` time NOT NULL,
  `toDate` time NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_shift`
--

INSERT INTO `mvoe_shift` (`shiftId`, `plan`, `fromDate`, `toDate`) VALUES
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
-- Tabellenstruktur für Tabelle `mvoe_worker`
--

CREATE TABLE `mvoe_worker` (
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `production` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_worker`
--

INSERT INTO `mvoe_worker` (`name`, `email`, `production`, `plan`, `shift`) VALUES
('123 123', 'asddsdsa', 'Bier', 'Mittwoch', 18),
('123123 123', 'dsasad', 'Bier', 'Mittwoch', 18);

--
-- Trigger `mvoe_worker`
--
DELIMITER $$
CREATE TRIGGER `Worker_History_Delete` AFTER DELETE ON `mvoe_worker`
 FOR EACH ROW INSERT INTO mvoe_worker_history 
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
CREATE TRIGGER `Worker_History_Insert` AFTER INSERT ON `mvoe_worker`
 FOR EACH ROW INSERT INTO mvoe_worker_history 
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
CREATE TRIGGER `Worker_History_Update` AFTER UPDATE ON `mvoe_worker`
 FOR EACH ROW IF NEW.name != OLD.name OR
  NEW.email != OLD.email
THEN
INSERT INTO mvoe_worker_history 
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
-- Tabellenstruktur für Tabelle `mvoe_worker_history`
--

CREATE TABLE `mvoe_worker_history` (
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
-- Daten für Tabelle `mvoe_worker_history`
--

INSERT INTO `mvoe_worker_history` (`historyId`, `nameBefore`, `nameAfter`, `emailBefore`, `emailAfter`, `production`, `plan`, `shift`, `action`, `created`) VALUES
(30, 'Dominik Honer', NULL, 'dh@web.de', NULL, 'Bar', 'Donnerstag', 6, 'delete', '2016-01-22 19:26:04'),
(31, 'Eileen Lehmann', NULL, 'lehmann@gmx.de', NULL, 'Bar', 'Donnerstag', 6, 'delete', '2016-01-22 19:26:04'),
(32, 'einer noch', NULL, 'asd@de.de', NULL, 'Geschirrmobil', 'Donnerstag', 2, 'delete', '2016-01-22 19:26:04'),
(33, 'Felix Honer', NULL, 'privat@feix-honer.com', NULL, 'Steak / Rote', 'Donnerstag', 3, 'delete', '2016-01-22 19:26:04'),
(34, 'Jana Honer', NULL, 'jhoner@web.de', NULL, 'Pommes', 'Donnerstag', 1, 'delete', '2016-01-22 19:26:04'),
(35, 'Jenny Zischek', NULL, 'zischek@gmx.de', NULL, 'Bar', 'Donnerstag', 6, 'delete', '2016-01-22 19:26:04'),
(36, 'Joachim Sattler', NULL, 'sattler@mvoe.de', NULL, 'Bar', 'Donnerstag', 6, 'delete', '2016-01-22 19:26:04'),
(37, 'noch einerrrrrrrr', NULL, 'asd@åsd.de', NULL, 'Geschirrmobil', 'Donnerstag', 2, 'delete', '2016-01-22 19:26:04'),
(38, 'Petti Coats', NULL, 'petti@coats.de', NULL, 'Bar', 'Donnerstag', 5, 'delete', '2016-01-22 19:26:04'),
(39, NULL, 'eins eins', NULL, 'eins@eins.de', 'Geschirrmobil', 'Donnerstag', 1, 'insert', '2016-01-22 19:46:26'),
(40, NULL, 'zwei zwei', NULL, 'zwei@zwei.de', 'Geschirrmobil', 'Donnerstag', 1, 'insert', '2016-01-22 19:46:26'),
(41, NULL, 'asdasdsda', NULL, 'dasssad', 'Geschirrmobil', 'Donnerstag', 2, 'insert', '2016-01-22 19:48:01'),
(42, NULL, 'assdaads', NULL, 'dassadasd', 'Geschirrmobil', 'Donnerstag', 2, 'insert', '2016-01-22 19:48:01'),
(43, 'assdaads', NULL, 'dassadasd', NULL, 'Geschirrmobil', 'Donnerstag', 2, 'delete', '2016-01-22 19:48:08'),
(44, NULL, 'asdsdaasdsad', NULL, 'asdsdasdds', 'Geschirrmobil', 'Donnerstag', 2, 'insert', '2016-01-22 19:48:08'),
(45, 'asdasdsda', NULL, 'dasssad', NULL, 'Geschirrmobil', 'Donnerstag', 2, 'delete', '2016-01-22 19:48:16'),
(46, 'asdsdaasdsad', NULL, 'asdsdasdds', NULL, 'Geschirrmobil', 'Donnerstag', 2, 'delete', '2016-01-22 19:48:16'),
(50, 'eins eins', NULL, 'eins@eins.de', NULL, 'Geschirrmobil', 'Donnerstag', 1, 'delete', '2016-01-23 14:47:36'),
(51, 'zwei zwei', NULL, 'zwei@zwei.de', NULL, 'Geschirrmobil', 'Donnerstag', 1, 'delete', '2016-01-23 14:47:36'),
(52, NULL, 'sadadsasd', NULL, 'dsasad', 'Bier', 'Mittwoch', 18, 'insert', '2016-01-23 15:57:52'),
(53, 'sadadsasd', 'sadadsa', 'dsasad', 'dsasad', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:08:38'),
(54, 'sadadsa', 'asdasddsadsa', 'dsasad', 'dsasad', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:08:59'),
(55, 'asdasddsadsa', 'asdasddsadsa123', 'dsasad', 'dsasad', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:09:24'),
(56, 'asdasddsadsa123', 'asdasddsadsa1', 'dsasad', 'dsasad', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:10:42'),
(57, 'asdasddsadsa1', '123123 123', 'dsasad', 'dsasad', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:28:47'),
(58, NULL, 'asddsa das', NULL, 'asddsdsa', 'Bier', 'Mittwoch', 18, 'insert', '2016-01-23 16:28:47'),
(59, NULL, 'cccccccc', NULL, 'ccccccc', 'Bier', 'Mittwoch', 18, 'insert', '2016-01-23 16:28:47'),
(60, 'cccccccc', NULL, 'ccccccc', NULL, 'Bier', 'Mittwoch', 18, 'delete', '2016-01-23 16:31:32'),
(61, 'asddsa das', '123 123', 'asddsdsa', 'asddsdsa', 'Bier', 'Mittwoch', 18, 'update', '2016-01-23 16:31:32');

--
-- Trigger `mvoe_worker_history`
--
DELIMITER $$
CREATE TRIGGER `Insert_Email_Pending` AFTER INSERT ON `mvoe_worker_history`
 FOR EACH ROW INSERT INTO mvoe_email_pending (historyId) VALUES (new.historyId)
$$
DELIMITER ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `mvoe_email_pending`
--
ALTER TABLE `mvoe_email_pending`
  ADD PRIMARY KEY (`historyId`);

--
-- Indizes für die Tabelle `mvoe_email_subscriber`
--
ALTER TABLE `mvoe_email_subscriber`
  ADD PRIMARY KEY (`email`,`plan`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `mvoe_plan`
--
ALTER TABLE `mvoe_plan`
  ADD PRIMARY KEY (`name`);

--
-- Indizes für die Tabelle `mvoe_production`
--
ALTER TABLE `mvoe_production`
  ADD PRIMARY KEY (`name`,`plan`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `mvoe_production_shift`
--
ALTER TABLE `mvoe_production_shift`
  ADD PRIMARY KEY (`production`,`shift`),
  ADD KEY `fk_prodshift_shift_idx` (`shift`),
  ADD KEY `plan` (`plan`),
  ADD KEY `fk_prodshift_production` (`production`,`plan`);

--
-- Indizes für die Tabelle `mvoe_shift`
--
ALTER TABLE `mvoe_shift`
  ADD PRIMARY KEY (`shiftId`),
  ADD UNIQUE KEY `plan_2` (`plan`,`fromDate`,`toDate`),
  ADD KEY `plan` (`plan`);

--
-- Indizes für die Tabelle `mvoe_worker`
--
ALTER TABLE `mvoe_worker`
  ADD PRIMARY KEY (`name`,`shift`),
  ADD KEY `shift` (`shift`),
  ADD KEY `fk_worker_production_idx` (`production`),
  ADD KEY `plan` (`plan`),
  ADD KEY `fk_worker_production` (`production`,`plan`);

--
-- Indizes für die Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
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
-- AUTO_INCREMENT für Tabelle `mvoe_shift`
--
ALTER TABLE `mvoe_shift`
  MODIFY `shiftId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT für Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=62;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `mvoe_email_pending`
--
ALTER TABLE `mvoe_email_pending`
  ADD CONSTRAINT `mvoe_email_pending_ibfk_1` FOREIGN KEY (`historyId`) REFERENCES `mvoe_worker_history` (`historyId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_email_subscriber`
--
ALTER TABLE `mvoe_email_subscriber`
  ADD CONSTRAINT `mvoe_email_subscriber_ibfk_1` FOREIGN KEY (`plan`) REFERENCES `mvoe_plan` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_production`
--
ALTER TABLE `mvoe_production`
  ADD CONSTRAINT `fk_production_plan` FOREIGN KEY (`plan`) REFERENCES `mvoe_plan` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_production_shift`
--
ALTER TABLE `mvoe_production_shift`
  ADD CONSTRAINT `fk_prodshift_production` FOREIGN KEY (`production`, `plan`) REFERENCES `mvoe_production` (`name`, `plan`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prodshift_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_shift`
--
ALTER TABLE `mvoe_shift`
  ADD CONSTRAINT `fk_shift_plan` FOREIGN KEY (`plan`) REFERENCES `mvoe_plan` (`name`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_worker`
--
ALTER TABLE `mvoe_worker`
  ADD CONSTRAINT `fk_worker_production` FOREIGN KEY (`production`, `plan`) REFERENCES `mvoe_production` (`name`, `plan`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_worker_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
  ADD CONSTRAINT `fk_whistory_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_whistory_production` FOREIGN KEY (`production`, `plan`) REFERENCES `mvoe_production` (`name`, `plan`) ON DELETE CASCADE ON UPDATE CASCADE;
