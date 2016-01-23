-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Erstellungszeit: 21. Jan 2016 um 21:15
-- Server-Version: 5.5.42
-- PHP-Version: 7.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Datenbank: `schichtplaner`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_plan`
--

CREATE TABLE `mvoe_plan` (
  `name` varchar(100) NOT NULL,
  `public` datetime DEFAULT NULL,
  `editable` datetime DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_plan`
--

INSERT INTO `mvoe_plan` (`name`, `public`, `editable`, `created`) VALUES
('Donnerstag', '2020-01-20 20:00:00', '2020-01-20 20:00:00', '0000-00-00 00:00:00'),
('Mittwoch', NULL, NULL, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_production`
--

CREATE TABLE `mvoe_production` (
  `name` varchar(100) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_production`
--

INSERT INTO `mvoe_production` (`name`, `plan`, `position`) VALUES
('Alkoholfreie Getränke', 'Donnerstag', 2),
('Bar', 'Donnerstag', 10),
('Bier', 'Donnerstag', 0),
('Essen', 'Donnerstag', 4),
('Geschirrmobil', 'Donnerstag', 3),
('Grill', 'Donnerstag', 1),
('Kaffee/Kuchen', 'Donnerstag', 6),
('Pommes', 'Donnerstag', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_production_shift`
--

CREATE TABLE `mvoe_production_shift` (
  `production` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL,
  `required` int(11) NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_production_shift`
--

INSERT INTO `mvoe_production_shift` (`production`, `shift`, `required`) VALUES
('Alkoholfreie Getränke', 1, 1),
('Alkoholfreie Getränke', 2, 2),
('Alkoholfreie Getränke', 3, 2),
('Bar', 2, 5),
('Bar', 5, 2),
('Bar', 6, 2),
('Bar', 7, 2),
('Bier', 1, 4),
('Bier', 2, 5),
('Bier', 3, 4),
('Essen', 9, 0),
('Essen', 10, 0),
('Geschirrmobil', 1, 2),
('Geschirrmobil', 2, 2),
('Geschirrmobil', 3, 2),
('Grill', 1, 2),
('Grill', 2, 2),
('Grill', 3, 2),
('Kaffee/Kuchen', 8, 4),
('Pommes', 1, 2),
('Pommes', 2, 2),
('Pommes', 3, 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_shift`
--

CREATE TABLE `mvoe_shift` (
  `shiftId` int(11) NOT NULL,
  `plan` varchar(100) NOT NULL,
  `fromDate` time NOT NULL,
  `toDate` time NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

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
(3, 'Donnerstag', '18:30:00', '23:45:00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mvoe_worker`
--

CREATE TABLE `mvoe_worker` (
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `production` varchar(100) NOT NULL,
  `shift` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_worker`
--

INSERT INTO `mvoe_worker` (`name`, `email`, `production`, `shift`) VALUES
('09908890809', '56756567', 'Bar', 2),
('aergger', 'aregrgeagrea', 'Bar', 2),
('asdasdsda', 'dssadasd', 'Bar', 2),
('Dominik Honer', 'dh@web.de', 'Bar', 6),
('Eileen Lehmann', 'lehmann@gmx.de', 'Bar', 6),
('Felix Honer', 'privat@feix-honer.com', 'Grill', 3),
('Jana Honer', 'jhoner@web.de', 'Pommes', 1),
('kjljklkjlkjljkl', 'jkhhjkhjk', 'Bar', 2),
('Petti Coats', 'petti@coats.de', 'Bar', 5),
('Roland Ellwanger', 'dasasd@da.de', 'Bier', 1);

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
         shift,
         action)
	VALUES
		(old.name,
         null,
         old.email,
         null,
         old.production,
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
         shift,
         action)
	VALUES
		(null,
         new.name,
         null,
         new.email,
         new.production,
         new.shift,
         'insert')
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
  `shift` int(11) NOT NULL,
  `action` varchar(25) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `mvoe_worker_history`
--

INSERT INTO `mvoe_worker_history` (`historyId`, `nameBefore`, `nameAfter`, `emailBefore`, `emailAfter`, `production`, `shift`, `action`, `created`) VALUES
(1, 'Corina ott', 'Corina Ott edited', 'cott@gmx.de', 'cott@gmx.de', 'Bar', 6, 'update', '2016-01-20 15:43:52'),
(2, NULL, 'after insert', NULL, 'neu@inserted.com', 'Grill', 1, 'insert', '2016-01-20 15:47:57'),
(3, NULL, 'after', NULL, 'neu@inserted.com', 'Grill', 1, 'insert', '2016-01-20 15:48:19'),
(4, 'after', NULL, 'neu@inserted.com', NULL, 'Grill', 1, 'delete', '2016-01-20 15:50:00'),
(10, 'jana honer', 'Pommes', 'jhoner@web.de', '1', 'Pommes', 1, 'update', '2016-01-20 17:53:28'),
(11, 'Pommes', 'Jana Honer', '1', 'jhoner@web.de', 'Pommes', 1, 'update', '2016-01-20 17:59:05'),
(12, 'test eins', 'test einsbearbeitet', 'asd@de.de', 'asd@de.de', 'Geschirrmobil', 2, 'update', '2016-01-20 17:59:39'),
(13, NULL, 'test einerdazu', NULL, 'dazu@dazu.de', 'Geschirrmobil', 2, 'insert', '2016-01-20 17:59:39'),
(14, 'test einsbearbeitet', NULL, 'asd@de.de', NULL, 'Geschirrmobil', 2, 'delete', '2016-01-20 18:23:58'),
(15, 'test einerdazu', NULL, 'dazu@dazu.de', NULL, 'Geschirrmobil', 2, 'delete', '2016-01-20 19:55:38'),
(16, NULL, 'einer noch', NULL, 'asd@de.de', 'Geschirrmobil', 2, 'insert', '2016-01-20 19:55:38'),
(17, NULL, 'Judith Honer', NULL, 'jhoner@web.de', 'Kaffee/Kuchen', 8, 'insert', '2016-01-20 22:14:27'),
(18, 'Judith Honer', NULL, 'jhoner@web.de', NULL, 'Kaffee/Kuchen', 8, 'delete', '2016-01-21 08:52:46'),
(19, 'Corina Ott edited', NULL, 'cott@gmx.de', NULL, 'Bar', 6, 'delete', '2016-01-21 09:40:50'),
(20, 'Laura Schuster', NULL, 'ls@web.de', NULL, 'Bar', 6, 'delete', '2016-01-21 09:40:50'),
(21, 'einer noch', NULL, 'asd@de.de', NULL, 'Geschirrmobil', 2, 'delete', '2016-01-21 20:01:49'),
(22, 'noch einer', NULL, 'asd@åsd.de', NULL, 'Geschirrmobil', 2, 'delete', '2016-01-21 20:01:49'),
(23, NULL, 'lkjlkj', NULL, 'kjhkjhhkj', 'Bar', 2, 'insert', '2016-01-21 20:02:33'),
(24, NULL, 'kjljklkjlkjljkl', NULL, 'jkhhjkhjk', 'Bar', 2, 'insert', '2016-01-21 20:02:33'),
(25, NULL, '09908890809', NULL, '56756567', 'Bar', 2, 'insert', '2016-01-21 20:02:33'),
(26, NULL, 'öllöläö', NULL, 'opüoüpüop', 'Bar', 2, 'insert', '2016-01-21 20:02:33'),
(27, 'öllöläö', NULL, 'opüoüpüop', NULL, 'Bar', 2, 'delete', '2016-01-21 20:05:42'),
(28, 'lkjlkj', NULL, 'kjhkjhhkj', NULL, 'Bar', 2, 'delete', '2016-01-21 20:05:42'),
(29, 'Joachim Sattler', NULL, 'sattler@mvoe.de', NULL, 'Bar', 6, 'delete', '2016-01-21 20:05:46'),
(30, 'Jenny Zischek', NULL, 'zischek@gmx.de', NULL, 'Bar', 6, 'delete', '2016-01-21 20:05:46'),
(31, NULL, 'asdasd', NULL, 'asdasd', 'Bar', 2, 'insert', '2016-01-21 20:06:47'),
(32, NULL, '123123', NULL, '123123', 'Bar', 2, 'insert', '2016-01-21 20:06:47'),
(33, '123123', NULL, '123123', NULL, 'Bar', 2, 'delete', '2016-01-21 20:07:34'),
(34, 'asdasd', NULL, 'asdasd', NULL, 'Bar', 2, 'delete', '2016-01-21 20:07:34'),
(35, NULL, 'asdasdsda', NULL, 'dssadasd', 'Bar', 2, 'insert', '2016-01-21 20:09:29'),
(36, NULL, 'aergger', NULL, 'aregrgeagrea', 'Bar', 2, 'insert', '2016-01-21 20:09:29'),
(37, NULL, 'Roland Ellwanger', NULL, 'dasasd@da.de', 'Bier', 1, 'insert', '2016-01-21 20:14:58');

--
-- Indizes der exportierten Tabellen
--

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
  ADD KEY `fk_prodshift_shift_idx` (`shift`);

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
  ADD KEY `fk_worker_production_idx` (`production`);

--
-- Indizes für die Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
  ADD PRIMARY KEY (`historyId`),
  ADD KEY `emailAfter` (`emailAfter`),
  ADD KEY `production` (`production`),
  ADD KEY `shift` (`shift`),
  ADD KEY `production_2` (`production`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `mvoe_shift`
--
ALTER TABLE `mvoe_shift`
  MODIFY `shiftId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT für Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=38;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `mvoe_production`
--
ALTER TABLE `mvoe_production`
  ADD CONSTRAINT `fk_production_plan` FOREIGN KEY (`plan`) REFERENCES `mvoe_plan` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_production_shift`
--
ALTER TABLE `mvoe_production_shift`
  ADD CONSTRAINT `fk_prodshift_prod` FOREIGN KEY (`production`) REFERENCES `mvoe_production` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prodshift_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_shift`
--
ALTER TABLE `mvoe_shift`
  ADD CONSTRAINT `fk_shift_plan` FOREIGN KEY (`plan`) REFERENCES `mvoe_plan` (`name`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_worker`
--
ALTER TABLE `mvoe_worker`
  ADD CONSTRAINT `fk_worker_production` FOREIGN KEY (`production`) REFERENCES `mvoe_production` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_worker_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mvoe_worker_history`
--
ALTER TABLE `mvoe_worker_history`
  ADD CONSTRAINT `fk_whistory_production` FOREIGN KEY (`production`) REFERENCES `mvoe_production` (`name`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_whistory_shift` FOREIGN KEY (`shift`) REFERENCES `mvoe_shift` (`shiftId`) ON DELETE NO ACTION ON UPDATE CASCADE;
