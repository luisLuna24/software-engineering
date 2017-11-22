-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 09, 2017 at 09:17 PM
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
-- Table structure for table `USUARIO`
--

CREATE TABLE `USUARIO` (
  `Id` int(5) NOT NULL,
  `Usuario` varchar(15) CHARACTER SET utf8 NOT NULL,
  `Contrasena` varchar(15) CHARACTER SET utf8 NOT NULL,
  `Email` varchar(25) CHARACTER SET utf8 NOT NULL,
  `Padecimientos` text CHARACTER SET utf8,
  `Nombre` varchar(55) CHARACTER SET utf8 NOT NULL,
  `Nacimiento` date NOT NULL,
  `Sexo` char(1) CHARACTER SET utf8 NOT NULL,
  `Imagen` varchar(50) CHARACTER SET utf8 NOT NULL,
  `Medicamento` varchar(250) CHARACTER SET utf8 NOT NULL,
  `Sangre` varchar(5) CHARACTER SET utf8 NOT NULL,
  `Altura` double NOT NULL,
  `Peso` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USUARIO`
--

INSERT INTO `USUARIO` (`Id`, `Usuario`, `Contrasena`, `Email`, `Padecimientos`, `Nombre`, `Nacimiento`, `Sexo`, `Imagen`, `Medicamento`, `Sangre`, `Altura`, `Peso`) VALUES
(1000, 'luis4032', '240897', 'luis.lunapa@outlook.com', NULL, 'Luis Gerardo Luna Peña', '1997-08-24', 'M', '/profile', '', '', 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `USUARIO`
--
ALTER TABLE `USUARIO`
  ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `USUARIO`
--
ALTER TABLE `USUARIO`
  MODIFY `Id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
