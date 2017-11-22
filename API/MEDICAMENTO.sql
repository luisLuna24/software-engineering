-- phpMyAdmin SQL Dump
-- version 4.7.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 11, 2017 at 05:02 AM
-- Server version: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Proageing`
--

-- --------------------------------------------------------

--
-- Table structure for table `MEDICAMENTO`
--

CREATE TABLE `MEDICAMENTO` (
  `Id` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Dosis` int(11) NOT NULL,
  `Unidad` varchar(5) NOT NULL,
  `Desde` datetime DEFAULT NULL,
  `Hasta` datetime DEFAULT NULL,
  `intervalo` int(11) DEFAULT NULL,
  `ViaAdmon` varchar(30) NOT NULL,
  `needsToBeReminded` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MEDICAMENTO`
--

INSERT INTO `MEDICAMENTO` (`Id`, `Usuario`, `Nombre`, `Dosis`, `Unidad`, `Desde`, `Hasta`, `intervalo`, `ViaAdmon`, `needsToBeReminded`) VALUES
(2, 1000, 'Aspirina', 200, 'mg', '2017-11-13 13:10:05', '2017-12-19 19:10:08', 2, 'Oral', 0),
(3, 1000, 'Aspirina', 10, 'ml', '2017-11-17 17:10:11', '2017-12-02 02:10:15', 4, 'Oral', 0),
(4, 1000, 'Aspirina ', 200, 'ml', '2017-11-11 11:11:42', '2017-12-12 12:11:45', 2, 'Oral', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `MEDICAMENTO`
--
ALTER TABLE `MEDICAMENTO`
  ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `MEDICAMENTO`
--
ALTER TABLE `MEDICAMENTO`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
