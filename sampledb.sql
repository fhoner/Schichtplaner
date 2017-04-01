-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Erstellungszeit: 02. Apr 2017 um 01:37
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

INSERT INTO `planer_plan` (`name`, `public`, `editable`, `position`, `created`, `deleted`) VALUES
('Donnerstag 2016', '2020-01-01 01:34:27', '2020-01-20 01:34:27', 1, '2016-01-20 23:00:00', 0),
('Mittwoch 2016', '2020-01-01 21:22:23', '2016-02-20 21:22:23', 0, '2016-01-23 14:52:40', 0);

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
('Bar', 'Donnerstag 2016', 'Ralf Papst', 'stellv.vorsitz@mv-oeschelbronn.de', 10),
('Bier', 'Donnerstag 2016', 'Maximilian Moench', 'stellv.vorsitz@mv-oeschelbronn.de', 0),
('Bier', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0),
('Eingang', 'Mittwoch 2016', NULL, NULL, 0),
('Essen', 'Donnerstag 2016', 'Frank Werner', 'schrift@mv-oeschelbronn.de', 4),
('Geschirr-Mobil', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0),
('Geschirrmobil', 'Donnerstag 2016', 'Rene Wurfel', 'stellv.vorsitz@mv-oeschelbronn.de', 3),
('Kaffee/Kuchen', 'Donnerstag 2016', NULL, NULL, 6),
('Kasse', 'Donnerstag 2016', 'Stefan Biermann', '1.vorsitzender@mv-oeschelbronn.de', 0),
('Kasse', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0),
('Pommes', 'Donnerstag 2016', 'Frank Werner', 'schrift@mv-oeschelbronn.de', 0),
('Pommes', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0),
('Steak / Rote', 'Donnerstag 2016', 'Frank Werner', 'schrift@mv-oeschelbronn.de', 1),
('Steak / Rote', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0),
('Wein / Alkfrei', 'Donnerstag 2016', 'Kathrin Baier', 'stellv.vorsitz@mv-oeschelbronn.de', 2),
('Wein / Alkfrei', 'Mittwoch 2016', 'Felix Honer', 'privat@felix-honer.com', 0);

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

INSERT INTO `planer_production_shift` (`production`, `shift`, `plan`, `required`, `comment`) VALUES
('Bar', 5, 'Donnerstag 2016', 3, ''),
('Bar', 6, 'Donnerstag 2016', 8, ''),
('Bar', 7, 'Donnerstag 2016', 2, ''),
('Bier', 1, 'Donnerstag 2016', 4, ''),
('Bier', 2, 'Donnerstag 2016', 5, ''),
('Bier', 3, 'Donnerstag 2016', 4, ''),
('Bier', 18, 'Mittwoch 2016', 4, ''),
('Eingang', 18, 'Mittwoch 2016', 2, ''),
('Essen', 9, 'Donnerstag 2016', 5, ''),
('Essen', 10, 'Donnerstag 2016', 1, ''),
('Geschirr-Mobil', 18, 'Mittwoch 2016', 3, ''),
('Geschirrmobil', 1, 'Donnerstag 2016', 4, ''),
('Geschirrmobil', 2, 'Donnerstag 2016', 4, ''),
('Geschirrmobil', 3, 'Donnerstag 2016', 4, ''),
('Kaffee/Kuchen', 8, 'Donnerstag 2016', 4, ''),
('Kasse', 1, 'Donnerstag 2016', 12, ''),
('Kasse', 2, 'Donnerstag 2016', 4, ''),
('Kasse', 3, 'Donnerstag 2016', 4, ''),
('Kasse', 18, 'Mittwoch 2016', 4, ''),
('Pommes', 1, 'Donnerstag 2016', 3, ''),
('Pommes', 2, 'Donnerstag 2016', 3, ''),
('Pommes', 3, 'Donnerstag 2016', 3, ''),
('Pommes', 18, 'Mittwoch 2016', 2, ''),
('Steak / Rote', 1, 'Donnerstag 2016', 4, ''),
('Steak / Rote', 2, 'Donnerstag 2016', 4, ''),
('Steak / Rote', 3, 'Donnerstag 2016', 3, ''),
('Steak / Rote', 18, 'Mittwoch 2016', 4, ''),
('Wein / Alkfrei', 1, 'Donnerstag 2016', 2, ''),
('Wein / Alkfrei', 2, 'Donnerstag 2016', 3, ''),
('Wein / Alkfrei', 3, 'Donnerstag 2016', 2, ''),
('Wein / Alkfrei', 18, 'Mittwoch 2016', 2, '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_shift`
--

CREATE TABLE `planer_shift` (
  `shiftId` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `fromDate` time NOT NULL,
  `toDate` time NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_shift`
--

INSERT INTO `planer_shift` (`shiftId`, `plan`, `fromDate`, `toDate`) VALUES
(1, 'Donnerstag 2016', '09:30:00', '14:00:00'),
(9, 'Donnerstag 2016', '10:30:00', '15:00:00'),
(8, 'Donnerstag 2016', '12:00:00', '17:00:00'),
(5, 'Donnerstag 2016', '12:00:00', '17:30:00'),
(2, 'Donnerstag 2016', '14:00:00', '18:30:00'),
(10, 'Donnerstag 2016', '15:00:00', '16:00:00'),
(7, 'Donnerstag 2016', '15:00:00', '19:00:00'),
(6, 'Donnerstag 2016', '17:30:00', '00:30:00'),
(3, 'Donnerstag 2016', '18:30:00', '23:45:00'),
(18, 'Mittwoch 2016', '17:30:00', '23:00:00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_user`
--

CREATE TABLE `planer_user` (
  `name` varchar(25) NOT NULL,
  `password` char(64) NOT NULL,
  `salt` char(25) NOT NULL,
  `lastchange` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastlogin` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_user`
--

INSERT INTO `planer_user` (`name`, `password`, `salt`, `lastchange`, `lastlogin`) VALUES
('user', '3e3e85fd583e0992a14e53bcf66c55b7aa5559e8450b3235309ff6110264f892', '6SsMLRPRmhntLlo7roamnny9p', '2017-04-01 23:33:26', '2017-04-01 23:33:34');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `planer_worker`
--

CREATE TABLE `planer_worker` (
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `production` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `isFixed` tinyint(1) NOT NULL DEFAULT '1',
  `position` int(11) NOT NULL DEFAULT '500'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_worker`
--

INSERT INTO `planer_worker` (`name`, `email`, `production`, `plan`, `shift`, `isFixed`, `position`) VALUES
('Angelika Ackermann', 'asd@asd.de', 'Pommes', 'Donnerstag 2016', 2, 0, 1),
('asd asd', 'asd@asd.de', 'Eingang', 'Mittwoch 2016', 18, 1, 500),
('Barbara Sankt', 'asd@asd.de', 'Wein / Alkfrei', 'Donnerstag 2016', 1, 1, 500),
('Franziska Metzger', 'asd@asd.de', 'Pommes', 'Donnerstag 2016', 2, 0, 2),
('Kathrin Traugott', 'asd@asd.de', 'Pommes', 'Donnerstag 2016', 2, 1, 0),
('Lena Abt', 'labt@icloud.com', 'Bier', 'Donnerstag 2016', 1, 1, 1),
('Matthias Theissen', 'mtheissen@gmail.com', 'Bier', 'Donnerstag 2016', 1, 1, 0);

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
     	 isFixedBefore,
     	 isFixedAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (old.name,
         null,
         old.email,
         null,
     	 old.isFixed,
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
     	 isFixedBefore,
      	 isFixedAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (null,
         new.name,
         null,
         new.email,
     	 null,
     	 new.isFixed,
         new.production,
         new.plan,
         new.shift,
         'insert')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Worker_History_Update` AFTER UPDATE ON `planer_worker`
 FOR EACH ROW IF NEW.name != OLD.name OR
  NEW.email != OLD.email OR
  NEW.isFixed != OLD.isFixed
THEN
INSERT INTO planer_worker_history 
    (nameBefore, 
         nameAfter, 
         emailBefore,
         emailAfter,
     	 isFixedBefore,
         isFixedAfter,
         production,
         plan,
         shift,
         action)
  VALUES
    (old.name,
         new.name,

         old.email,
         new.email,

     	 old.isFixed,
     	 new.isFixed,
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
  `isFixedBefore` tinyint(1) DEFAULT NULL,
  `isFixedAfter` tinyint(1) DEFAULT NULL,
  `production` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `action` varchar(25) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=622 DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `planer_worker_history`
--

INSERT INTO `planer_worker_history` (`historyId`, `nameBefore`, `nameAfter`, `emailBefore`, `emailAfter`, `isFixedBefore`, `isFixedAfter`, `production`, `plan`, `shift`, `action`, `created`) VALUES
(613, NULL, 'Matthias Theissen', NULL, 'mtheissen@gmail.com', NULL, 1, 'Bier', 'Donnerstag 2016', 1, 'insert', '2017-01-22 15:12:22'),
(614, NULL, 'Lena Abt', NULL, 'labt@icloud.com', NULL, 1, 'Bier', 'Donnerstag 2016', 1, 'insert', '2017-01-22 15:12:22'),
(615, NULL, 'Franziska Metzger', NULL, 'asd@asd.de', NULL, 1, 'Pommes', 'Donnerstag 2016', 2, 'insert', '2017-01-22 15:14:15'),
(616, NULL, 'Kathrin Traugott', NULL, 'asd@asd.de', NULL, 1, 'Pommes', 'Donnerstag 2016', 2, 'insert', '2017-01-22 15:14:15'),
(617, NULL, 'Angelika Ackermann', NULL, 'asd@asd.de', NULL, 1, 'Pommes', 'Donnerstag 2016', 2, 'insert', '2017-01-22 15:14:15'),
(618, NULL, 'Barbara Sankt', NULL, 'asd@asd.de', NULL, 1, 'Wein / Alkfrei', 'Donnerstag 2016', 1, 'insert', '2017-01-22 15:14:24'),
(619, NULL, 'asd asd', NULL, 'asd@asd.de', NULL, 1, 'Eingang', 'Mittwoch 2016', 18, 'insert', '2017-01-23 18:35:16'),
(620, 'Franziska Metzger', 'Franziska Metzger', 'asd@asd.de', 'asd@asd.de', 1, 0, 'Pommes', 'Donnerstag 2016', 2, 'update', '2017-03-30 23:41:47'),
(621, 'Angelika Ackermann', 'Angelika Ackermann', 'asd@asd.de', 'asd@asd.de', 1, 0, 'Pommes', 'Donnerstag 2016', 2, 'update', '2017-03-30 23:47:44');

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
-- Indizes für die Tabelle `planer_user`
--
ALTER TABLE `planer_user`
  ADD PRIMARY KEY (`name`),
  ADD UNIQUE KEY `name` (`name`);

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
  MODIFY `shiftId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=40;
--
-- AUTO_INCREMENT für Tabelle `planer_worker_history`
--
ALTER TABLE `planer_worker_history`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=622;
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
  ADD CONSTRAINT `fk_whistory_production` FOREIGN KEY (`production`, `plan`) REFERENCES `planer_production` (`name`, `plan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_whistory_shift` FOREIGN KEY (`shift`) REFERENCES `planer_shift` (`shiftId`) ON DELETE CASCADE ON UPDATE CASCADE;
