-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 10, 2024 at 07:29 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `infertilityapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `addpatient`
--

CREATE TABLE `addpatient` (
  `Userid` int(20) NOT NULL,
  `Name` varchar(50) NOT NULL DEFAULT 'name',
  `ContactNo` varchar(50) NOT NULL DEFAULT 'contactnumber',
  `Age` varchar(50) NOT NULL DEFAULT 'age',
  `Gender` varchar(50) NOT NULL DEFAULT 'gender',
  `Height` varchar(50) NOT NULL DEFAULT 'height',
  `Weight` varchar(50) NOT NULL DEFAULT 'weight',
  `Marriageyear` varchar(50) NOT NULL DEFAULT 'yom',
  `Bloodgroup` varchar(50) NOT NULL DEFAULT 'bloodgroup',
  `Medicalhistory` varchar(1000) NOT NULL DEFAULT 'medicalhistory',
  `Specifications` varchar(1000) NOT NULL DEFAULT 'NO SPECIFICATIONS SPECIFIED',
  `password` varchar(50) NOT NULL DEFAULT 'WELCOME',
  `repassword` varchar(50) NOT NULL DEFAULT 'WELCOME',
  `image` varchar(300) NOT NULL,
  `occupation` varchar(255) NOT NULL,
  `BMI` decimal(5,2) NOT NULL,
  `contraceptive_history` text NOT NULL,
  `last_menstrual_period` varchar(50) NOT NULL,
  `menstrual_history` text NOT NULL,
  `flow` text NOT NULL,
  `consanguineous` varchar(1) NOT NULL,
  `coital_history` text NOT NULL,
  `obstetric_history` text NOT NULL,
  `surgical_history` text NOT NULL,
  `smoking` varchar(1) NOT NULL,
  `alcohol` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addpatient`
--

INSERT INTO `addpatient` (`Userid`, `Name`, `ContactNo`, `Age`, `Gender`, `Height`, `Weight`, `Marriageyear`, `Bloodgroup`, `Medicalhistory`, `Specifications`, `password`, `repassword`, `image`, `occupation`, `BMI`, `contraceptive_history`, `last_menstrual_period`, `menstrual_history`, `flow`, `consanguineous`, `coital_history`, `obstetric_history`, `surgical_history`, `smoking`, `alcohol`) VALUES
(205, 'geetha', '5486478434', '23', 'female', '5.5', '45', '2006', 'O+', 'Nil', 'thanks for your precious advice', '05', '05', 'patient_image/6635bd640fc08.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(210, 'Babitha devi', '1625353890', '42', 'Female', '5.0', '50', '2003', 'A+', 'Bp', 'Go walking daily and drink fruit juices.', '10', '10', '', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(361, 'Gayathri', '1234567890', '21', 'female', '161', '67', '2022', 'B+', 'nil', 'NO SPECIFICATIONS SPECIFIED', 'gayu', 'gayu', 'patient_image/66a399d1ee539.jpg', 'teacher', 23.00, 'nil', '2024-07-08', 'regular', 'scanty', 'n', 'nil', 'nil', 'nil', 'n', 'n'),
(362, 'sushmija', '52738399292', '24', 'Female', '4.8', '40', '2020', 'B-', 'height is very short', 'did exercise many times do increase height.', '62', '62', '', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(363, 'ramya', '7275372992', '30', 'Female', '5.6', '60', '2015', 'O-', 'Nill', 'Don\'t get tensed and be calm.', ' ', ' ', 'patient_image/6635eefbf37ae.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(364, 'poorni', '8272628299', '20', 'Female', '5.5', '60', '2024', 'AB+', 'Nill', 'NO SPECIFICATIONS SPECIFIED', ' ', ' ', 'patient_image/6635ee6f91bb4.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(365, 'shivani', '5476984323', '28', 'Female', '5.6', '63', '2015', 'AB+', 'Nill', 'Take care', '65', '65', 'patient_image/6635c2677c27e.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(373, 'rithanya', '1235578900', '21', 'female', '5.3', '55', '2022', 'B+', 'Nil', 'Take care\n', ' ', ' ', 'patient_image/6635eefbf37ae.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(374, 'prathiba', '6373830337', '31', 'female', '5.6', '56', '2007', 'O+', 'Nil', 'NO SPECIFICATIONS SPECIFIED', '74', '74', 'patient_image/6635ee6f91bb4.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(375, 'kavi', '1234556789', '27', 'Female', '5.6', '67', '2017', 'B-', 'Nill', 'NO SPECIFICATIONS SPECIFIED', '75', '75', 'patient_image/6635c2677c27e.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(382, 'sushmi', '6272828828', '22', 'Female', '4.8', '43', '2024', 'B+', 'Nill', 'i have already done this specifications', '82', '82', 'patient_image/6635f477632c5.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(384, 'sofia', '4358769320', '26', 'Female', '5.8', '67', '2017', 'B+', 'Nill', 'thanks for the advice and for taking care of me.', '84', '84', 'patient_image/6635c2677c27e.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(387, 'Desi', '8749494030', '20', 'Female', '5.2', '45', '2017', 'O+', 'nil', 'Do exercise and maintain scheduled sleep,drink water\n', '87', '87', 'patient_image/663e50085029b.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(390, 'kavitha', '8765432109', '26', 'Female', '5.6', '65', '2016', 'A-', 'nill', 'thanks for the specification given before\n', ' 90', ' 90', 'patient_image/6635eefbf37ae.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(392, 'manisha', '7262727278', '29', 'Female', '5.7', '50', '2017', 'AB+', 'had pcos', 'had pcos but treated well now I am good ', '92', '92', 'patient_image/665d9fad243b3.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(393, 'aarthi', '9876765646', '27', 'Female', '5.4', '60', '2017', 'AB+', 'nil', 'hii', '93', '93', 'patient_image/6635ee6f91bb4.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(396, 'hema', '7896541237', '35', 'female', '6.0', '70', '2022', 'O+', 'Nil', 'had harmone pills for thyroid\n', '96', '96', 'patient_image/668c203f46c6c.jpg', 'engineer', 23.00, 'nill', '2024-06-01', 'regular', 'normal', 'n', 'nil', 'no', 'no', 'n', 'n'),
(397, 'gobi', '6756453433', '26', 'Female', '5.3', '60', '2022', 'A+', 'nil', '', ' ', ' ', 'patient_image/6688ff716f3fe.jpg', '', 0.00, '', '0000-00-00', '', '', '', '', '', '', '', ''),
(413, 'indumathi', '9487705958', '45', 'Female', '156 cm', '65 kg', '2004', 'B+', 'nill', 'NO SPECIFICATIONS SPECIFIED', '13', '13', 'patient_image/668d2490c53e4.jpg', 'housewife', 25.00, 'nill', '0000-00-00', 'regular', 'severe', 'n', 'nill', 'nill', 'yes due to operation for birth of the baby', 'n', 'n'),
(414, 'nivi', '2739625783', '24', 'Female', '156 cm', '60 kg', '2024', 'O+', 'nill', 'NO SPECIFICATIONS SPECIFIED', '14', '14', 'patient_image/668ecbf3621a3.jpg', 'engineer ', 24.00, 'nill', '06/06/2024', 'regular', 'moderate', 'n', 'nill', 'nill', 'nill', 'n', 'n'),
(417, 'jayz', '6372826492', '23', 'Female', '156 cm', '56 kg', '2024', 'AB-', 'nakdkdndnbdjdjdkdkemdnnxhcjdidjskdmsksojdjdhsbbs shdhuxisksksn dhdjsikeksmndhdjdoodkdndnndkdkxhyxkdnd smsmskkdk', 'NO SPECIFICATIONS SPECIFIED', ' ', ' ', 'patient_image/6692a1ffd210e.jpg', 'teacher', 24.00, 'nill', '06/07/2024', 'regular', 'moderate', 'n', 'nill', 'nill', 'nill', 'n', 'n'),
(419, 'nisha', '6272828288', '26', 'Female', '156 cm', '66 kg', '2020', 'B+', 'nill', 'NO SPECIFICATIONS SPECIFIED', '19', '19', 'patient_image/66974c297464c.jpg', 'teacher', 25.00, 'nill', '29/06/2024', 'regular', 'moderate', 'y', 'nill', 'nill', 'nill', 'n', 'n'),
(426, 'Lavanya', '9080347789', '21', 'Female', '156 cm', '53 kg', '2024', 'B+', 'nill', 'bdjdjdkdkmdndh dbdgdyusdbbdhdj dbdjkdjcgdjn dndn hdhs ydjd hdkskjdbdb dhdjdk\n', '26', '26', 'patient_image/66a399e08e950.jpg', 'student', 24.50, 'no I don\'t have contraceptive history', '06/08/2024', 'irregular', 'moderate', 'n', 'nil', 'nil', 'no surgical history till now ', 'n', 'n');

-- --------------------------------------------------------

--
-- Table structure for table `addreport`
--

CREATE TABLE `addreport` (
  `id` int(11) NOT NULL,
  `Userid` varchar(20) NOT NULL,
  `date` varchar(40) NOT NULL,
  `endometrium_thickness` varchar(50) NOT NULL,
  `follicular_diameter` varchar(50) NOT NULL,
  `perifollicular_rate` varchar(50) NOT NULL,
  `RI` varchar(50) NOT NULL,
  `PSV` varchar(50) NOT NULL,
  `FSH` varchar(50) NOT NULL,
  `LH` varchar(50) NOT NULL,
  `TSH` varchar(50) NOT NULL,
  `Prolactin` varchar(50) NOT NULL,
  `AMH` varchar(50) NOT NULL,
  `HSG_report` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addreport`
--

INSERT INTO `addreport` (`id`, `Userid`, `date`, `endometrium_thickness`, `follicular_diameter`, `perifollicular_rate`, `RI`, `PSV`, `FSH`, `LH`, `TSH`, `Prolactin`, `AMH`, `HSG_report`) VALUES
(46, '361', '2024-04-10', '0.3', '0.4', '0.03', '0', '0', '0', '', '', '', '', ''),
(47, '243', '2024-04-11', '0.4', '0.3', '0.3', '0', '0', '0', '', '', '', '', ''),
(52, '360', '2024-04-09', '0.1', '0.3', '0.5', '0', '0', '0', '', '', '', '', ''),
(53, '360', '2024-04-10', '0.4', '0.6', '0.5', '0', '0', '0', '', '', '', '', ''),
(57, '222', '2024-04-19', '0.8', '0.6', '0.4', '0', '0', '0', '', '', '', '', ''),
(59, '374', '2024-04-23', '0.7', '0.5', '0.2', '0', '0', '0', '', '', '', '', ''),
(60, '356', '2024-04-25', '0.6', '0.5', '0.8', '0', '0', '0', '', '', '', '', ''),
(64, '365', '2024-06-10', '0.6', '0.9', '0.4', '0', '0', '0', '', '', '', '', ''),
(66, '393', '2024-06-15', '0.6', '0.5', '0.3', '0', '0', '0', '', '', '', '', ''),
(67, '387', '2024-07-06', '0.6', '0.6', '0.9', '0', '0', '0', '', '', '', '', ''),
(68, '387', '2024-07-03', '0.4', '0.9', '0.7', '0', '0', '0', '', '', '', '', ''),
(72, '396', '2024-07-08', '0.3', '0.9', '0.5', '0.9', '0.3', '0.5', '', '', '', '', ''),
(73, '392', '2024-07-08', '0.7', '0', '0', '0.7', '0.7', '0.7', '', '', '', '', ''),
(76, '384', '2024-07-10', '10', '10', '10', '10', '10', '10', '10', '10', '10', '10', '10'),
(78, '382', '2024-07-10', '20', '20', '20', '20', '20', '20', '20', '20', '20', '20', 'normal'),
(80, '419', '2024-07-18', '9', '18', '6', '0.3', '12', '30', '7', '22', '31', '29', '30'),
(83, '426', '2024-12-08', '9', '18', '67', '0.1', '44', '22', '18', '43', '52', '55', '78'),
(84, '426', '2024-12-09', '8', '30', '45', '0.5', '34', '45', '23', '76', '13', '24', '55');

-- --------------------------------------------------------

--
-- Table structure for table `addspouse`
--

CREATE TABLE `addspouse` (
  `id` int(11) NOT NULL,
  `Userid` varchar(20) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Contactnumber` varchar(20) NOT NULL,
  `occupation` varchar(20) NOT NULL,
  `Age` varchar(50) NOT NULL,
  `significanthistory` varchar(100) NOT NULL,
  `smoking` varchar(10) NOT NULL,
  `alcohol` varchar(10) NOT NULL,
  `sexualdisfunction` varchar(10) NOT NULL,
  `Volume` float NOT NULL,
  `Concentration` float NOT NULL,
  `Total_sperm_number` int(11) NOT NULL,
  `Motility` float NOT NULL,
  `Progressive_Motility` float NOT NULL,
  `Morphology` float NOT NULL,
  `Viability` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addspouse`
--

INSERT INTO `addspouse` (`id`, `Userid`, `Name`, `Contactnumber`, `occupation`, `Age`, `significanthistory`, `smoking`, `alcohol`, `sexualdisfunction`, `Volume`, `Concentration`, `Total_sperm_number`, `Motility`, `Progressive_Motility`, `Morphology`, `Viability`) VALUES
(38, '205', 'Krishna', '789654123', '120', '53', 'hi', 'yes', 'no', '', 0, 0, 0, 0, 0, 0, 0),
(91, '360', 'Abay Kumar', '6282913690', '65', '48', 'nil', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(92, '361', 'manoj', '5462138790', '65', '23', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(93, '362', 'vaishna', '9352782920', '60', '24', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(94, '363', 'Alwin', '5206256875', '65', '32', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(95, '364', 'sidharth ', '8282626828', '58', '25', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(96, '365', 'satyam', '4574268689', '60', '30', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(97, '373', 'karan', '8765432890', '80', '24', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(98, '374', 'Vaithyalingam', '7254674388', '75', '40', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(99, '375', 'eswar', '5272828298', '75', '30', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(100, '382', 'jack', '9282762799', '70', '25', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(101, '384', 'julian', '6435788598', '78', '30', 'Nill', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(102, '387', 'rahul', '9484937282', '50', '28', 'nil', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(103, '390', 'sekar', '7654329180', '78', '30', 'nil', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(104, '392', 'sree', '2526282886', '65', '32', 'nil', '', '', '', 0, 0, 0, 0, 0, 0, 0),
(105, '393', 'ram', '5647386209', '70', '29', 'nil', 'no', 'no', '', 0, 0, 0, 0, 0, 0, 0),
(106, '396', 'rithuraj', '1235578900', '55', '29', 'Nil', 'yes', 'yes', '', 0, 0, 0, 0, 0, 0, 0),
(107, '397', 'kumar', '6756839988', '89', '29', 'nil', 'no', 'yes', '', 0, 0, 0, 0, 0, 0, 0),
(108, '398', 'arul', '5272728286', '80', '36', 'nil', 'yes', 'no', '', 0, 0, 0, 0, 0, 0, 0),
(110, '404', 'karthik', '7896541237', 'engineer', '35', 'Nil', 'no', 'yes', 'no', 0, 0, 0, 0, 0, 0, 0),
(111, '412', 'shivam', '3246483578', 'ips', '28', 'nill', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0),
(112, '413', 'vijayabalan', '9442205958', 'engineer', '55', 'nill', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0),
(113, '414', 'yuvaraj', '2837297382', 'engineer', '27', 'nill', 'no', 'yes', 'no', 23, 186, 37, 78, 67, 87, 82),
(114, '417', 'kumz', '6283838287', 'engineer ', '25', 'chhkkskksksns nsmsmbbnnhhhhnbvddshsjsjjsjsj snsjsjsjsnnsjsn', 'no', 'no', 'no', 56, 34, 2, 89, 94, 86, 78),
(115, '419', 'nishant', '728292929', 'instructor', '30', 'nill', 'no', 'no', 'no', 78, 23, 4, 89, 96, 87, 59),
(118, '424', 'nennee', '0', 'nnmkansn', 'vsnsj', 'bsnsmks', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0),
(119, '426', 'abdul', '7364826836', 'student', '22', 'nill', 'no', 'no', 'no', 45, 3, 6, 89, 98, 78, 94),
(120, '427', '', '', '', '', '', '', '', '', 72, 2, 4, 98, 87, 99, 78),
(121, '428', 'fhjj', '3574268464', 'fhjj', '34', 'cgjk', 'no', 'no', 'no', 34, 5, 4, 34, 85, 80, 87),
(122, '429', 'arun', '8393628299', 'engineer', '30', 'nil', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0),
(123, '431', 'ycyc', 'zgu', 'cv', 'fh', 'cb', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0),
(124, '432', 'stick ', '7262562899', 'engineer', '34', 'nil', 'no', 'no', 'no', 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `advices`
--

CREATE TABLE `advices` (
  `id` int(11) NOT NULL,
  `Userid` varchar(20) NOT NULL,
  `Date` date NOT NULL,
  `Addadvices` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `advices`
--

INSERT INTO `advices` (`id`, `Userid`, `Date`, `Addadvices`) VALUES
(27, '205', '2023-12-18', 'Gd'),
(28, '205', '2023-12-18', 'Hii'),
(29, '360', '2023-12-18', 'Take care'),
(32, '243', '2023-12-19', 'Hlo'),
(42, '365', '2024-01-31', ' Bad'),
(46, '205', '2024-02-06', 'good'),
(47, '362', '2024-03-04', 'Good'),
(49, '205', '2024-03-08', 'Good medical report'),
(50, '205', '2024-04-19', 'your reports are very bad u are in more risk please be safe drink more water do exercises eat more vegetables by these ur reports can be good hereafter so please be safe '),
(51, '222', '2024-04-20', 'very good take care'),
(52, '360', '2024-04-22', 'take care '),
(53, '222', '2024-04-22', 'left ovary is weak'),
(54, '205', '2024-04-22', 'good report'),
(55, '243', '2024-04-22', 'good report left and right ovary size are good but endometrium size is very large so do exercise daily and drink more water.'),
(56, '374', '2024-04-23', 'Good report maintain this by taking the medicines correctly,do more exercises and drink more water.'),
(60, '382', '2024-05-06', 'right ovary size is alone large do exercise and maintain a good healthy lifestyle by eating healthy foods and drinking water regularly.'),
(61, '387', '2024-05-10', 'left ovary is smaller than right ovary so take care'),
(62, '205', '2024-05-14', 'take care'),
(63, '365', '2024-06-10', 'good'),
(64, '205', '2024-06-10', 'good'),
(65, '393', '2024-07-06', 'take care '),
(66, '419', '2024-07-18', 'v good \ntake care'),
(67, '426', '2024-07-26', 'take care and do more exercises regularly and drink more water '),
(68, '419', '2024-09-03', 'Take Care'),
(69, '426', '2024-10-25', 'tc and have good food '),
(70, '426', '2024-12-08', 'take care and maintain this health \nok good but ur RI is not good 💯\n👍🏻\n👍🏻');

-- --------------------------------------------------------

--
-- Table structure for table `cycleupdate`
--

CREATE TABLE `cycleupdate` (
  `id` int(11) NOT NULL,
  `userid` varchar(20) NOT NULL,
  `date` varchar(40) NOT NULL,
  `days` varchar(30) NOT NULL,
  `fertileStart` varchar(15) NOT NULL,
  `fertileEnd` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cycleupdate`
--

INSERT INTO `cycleupdate` (`id`, `userid`, `date`, `days`, `fertileStart`, `fertileEnd`) VALUES
(1, '205', '2024/07/09', '5', '2024-07-15', '2024-07-19'),
(2, '360', '2024/06/01', '9', '', ''),
(3, '210', '2024-06-28', '13', '2024/07/19', '2024/07/23'),
(4, '222', '2024/04/16', '61', '', ''),
(5, '218', '2024/03/06', '94', '', ''),
(6, '355', '2024/04/13', '56', '', ''),
(7, '358', '2024/04/16', '53', '', ''),
(8, '365', '2024/05/23', '24', '', ''),
(9, '362', '2024/04/19', '50', '', ''),
(10, '219', '2024/05/02', '8', '', ''),
(11, '374', '2024/06/11', '5', '', ''),
(12, '387', '2024/07/03', '4', '', ''),
(17, '382', '2024-06-01', '15', '', ''),
(18, '392', '2024/07/03', '4', '', ''),
(19, '391', '2024/06/14', '2', '', ''),
(20, '393', '2024-07-02', '9', '', ''),
(27, '413', '2024/07/10', '3', '', ''),
(28, '414', '2024/07/10', '3', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `cycleupdate2`
--

CREATE TABLE `cycleupdate2` (
  `userid` varchar(200) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cycleupdate2`
--

INSERT INTO `cycleupdate2` (`userid`, `date`) VALUES
('205', '2024-10-31'),
('210', '2024-07-30'),
('384', '2024-06-20'),
('419', '2024-08-29'),
('426', '2024-11-29'),
('427', '2024-07-11');

-- --------------------------------------------------------

--
-- Table structure for table `datep`
--

CREATE TABLE `datep` (
  `id` int(11) NOT NULL,
  `userid` varchar(111) NOT NULL,
  `datep` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `datep`
--

INSERT INTO `datep` (`id`, `userid`, `datep`) VALUES
(1, '205', '2024-07-12'),
(2, '210', '2024-07-30'),
(3, '222', '2024-07-16'),
(4, '218', '2024-06-06'),
(5, '360', '2024-06-29'),
(6, '205', '2024-07-30'),
(7, '419', '2024-07-10'),
(8, '205', '2024-07-04'),
(9, '205', '2024-08-08'),
(10, '419', '2024-08-29'),
(11, '205', '2024-10-01'),
(12, '205', '2024-10-01'),
(13, '205', '2024-08-01'),
(14, '205', '2024-10-01'),
(15, '426', '2024-07-24'),
(16, '426', '2024-10-23'),
(17, '205', '2024-10-31'),
(18, '426', '2024-11-29');

-- --------------------------------------------------------

--
-- Table structure for table `degignation`
--

CREATE TABLE `degignation` (
  `id` int(11) NOT NULL,
  `role` varchar(11) NOT NULL,
  `did` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `degignation`
--

INSERT INTO `degignation` (`id`, `role`, `did`) VALUES
(1, 'doctor', 1),
(2, 'paitent', 2);

-- --------------------------------------------------------

--
-- Table structure for table `doctor_profile`
--

CREATE TABLE `doctor_profile` (
  `dr_userid` int(11) NOT NULL,
  `dr_name` varchar(30) NOT NULL DEFAULT 'welcome',
  `email` varchar(20) NOT NULL DEFAULT '@gmail.com',
  `password` varchar(20) NOT NULL DEFAULT 'welcome',
  `designation` varchar(20) NOT NULL DEFAULT 'designation',
  `contact_no` varchar(20) NOT NULL DEFAULT 'contactnumber',
  `repassword` varchar(20) NOT NULL,
  `doctorimage` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_profile`
--

INSERT INTO `doctor_profile` (`dr_userid`, `dr_name`, `email`, `password`, `designation`, `contact_no`, `repassword`, `doctorimage`) VALUES
(1920, 'Kavya', 'Kavya@gmail.com', '20', 'Ortho', '9087654346', '20', 'doctor_image/1000130409.jpg'),
(192011305, 'gowtami', '123@gmail.com', '1', 'ortho', '1234567890', '1', ''),
(192011341, 'nivi', 'nivi@gmail.com', '341', 'neuro', '8336790257', '341', ''),
(192011342, 'satyam', 'satyam@gmail.com', '2004', 'cardio', '1234567890', '2004', ''),
(192011343, 'Jaya', 'gobiga@gmail.com', '2104', 'gynecologist', '9876543210', '2104', ''),
(192011385, 'gobi', 'gobi@gmail.com', '2116', 'ortho', '1234567890', '2116', ''),
(192011441, 'aarthi ', 'aarthi@gmail.com', '441', 'ortho', '1234567890', '441', ''),
(192011442, 'lavanya ', 'lavanya@gmail.com', 'welcome', 'biomedical', '9345672937', '', ''),
(192011444, 'desi', 'desi@gmail.com', 'welcome', 'aids', '3344556677', '', ''),
(192011445, 'gayu', 'gayathri@gmail.com', 'welcome', 'IT', '8903705959', '', ''),
(192011447, 'nitish', 'niti@gmail.com', 'welcome', 'AIDS', '9273652728', '', ''),
(192011448, 'Daya', 'Daya@gmail.com', 'daya', 'pediatrician ', '9638305958', 'daya', ''),
(192011449, 'vijay', 'vijay@gmail.com', 'welcome', 'doctor', '5268292020', '', ''),
(192011450, 'satyam', 'satyam@gmail.com', '450', 'gynacologist', '9543956924', '', 'doctor_image/1000119937.jpg'),
(192011454, 'swathi', 'swathi@gmail.com', 'welcome', 'dentist', '1546846651', '', 'doctor_image/66388d245bf76.jpg'),
(192011462, 'swetha', 'swetha@gmail.com', 'welcome', 'ortho', '9876654322', '', 'doctor_image/663900d1b59f4.jpg'),
(192011463, 'Desika', 'desika@gmail.com', 'welcome', 'dentist', '6272829299', '', 'doctor_image/6639011a2dcf1.jpg'),
(192011464, 'jeni', 'jeni@gmail.com', 'welcome', 'nurse', '8273738288', '', 'doctor_image/66390be4edb54.jpg'),
(192011465, 'mutta', 'jaya@gmail.com', '28', 'gynacologist', '9087654320', '', 'doctor_image/1000045777.jpg'),
(192011470, 'nitish', 'niti@gmail.com', 'welcome', 'cardio', '7353282684', '', 'doctor_image/665d9da68b19e.jpg'),
(192011471, 'satyam', 'satyam@gmail.com', 'welcome', 'ortho', '7676545434', '', 'doctor_image/6666d259c7efb.jpg'),
(192011472, 'gobz', 'gobz@gmail.com', '472', 'doctor ', '8907654545', '472', 'doctor_image/666d7d6fae980.jpg'),
(192011475, 'daya', 'daya@gmail.com', '475', 'pediatrician ', '4523876545', '475', 'doctor_image/6688fa39df00a.jpg'),
(192011476, 'harini', 'harini@gmail.com', 'welcome', 'ortho', '7654356797', '', 'doctor_image/6688fed71f501.jpg'),
(192011477, 'gobzz', 'gobzz@gmail.com', 'welcome', 'gynacologist ', '2527282829', '', 'doctor_image/669166375c60f.jpg'),
(192011478, 'jayss', 'jays@gmail.com', 'welcome', 'ortho', '6282572966', '', 'doctor_image/669752066d26c.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `medicationdetails`
--

CREATE TABLE `medicationdetails` (
  `id` int(11) NOT NULL,
  `Userid` varchar(20) NOT NULL,
  `Medication` varchar(30) NOT NULL,
  `Time` varchar(30) NOT NULL,
  `Dosage` varchar(15) NOT NULL,
  `Route` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medicationdetails`
--

INSERT INTO `medicationdetails` (`id`, `Userid`, `Medication`, `Time`, `Dosage`, `Route`, `date`) VALUES
(98, '360', 'bp tablet ', '2', '2', '', '2024-04-01'),
(100, '219', 'cough syrup ', '2', '2', '', '2024-04-03'),
(101, '222', 'naselin', '1', '1', '', '2024-04-05'),
(102, '361', 'biplex ', '3', '3', '', '2024-04-07'),
(104, '218', 'motrin ib', '1', '1', '', '2024-04-09'),
(105, '362', 'complan', '4', '4', '', '2024-04-10'),
(106, '243', 'citrazin', '1', '1', '', '2024-04-10'),
(109, '365', 'aspirin', '1', '1', '', '2024-04-13'),
(110, '363', 'dolo', '3', '3', '', '2024-04-14'),
(111, '210', 'ajithromaizin', '2', '2', '', '2024-04-16'),
(112, '355', 'dolo', '3', '3', '', '2024-04-18'),
(116, '374', 'aderall', '1', '1', '', '2024-04-23'),
(117, '382', 'headache medicine ', '3', '3', '', '2024-05-06'),
(118, '387', 'Paracetamol ', '2', '2', '', '2024-05-10'),
(119, '205', 'Ciplex', '3', '3', '', '2024-05-14'),
(120, '392', 'clomifene', '1', '1', '', '2024-06-03'),
(121, '393', 'dolo', '2', '2', '', '2024-06-10'),
(122, '393', 'paracetamol ', '3', '3', '', '2024-06-10'),
(124, '412', 'dolo', '2', '20mg', '', '2024-07-09'),
(125, '413', 'jsks', 'sbsj', 'sbsn', 'ahs', '2024-07-10'),
(126, '413', 'TAMOXIFEN', '2', '200mg', 'Oral', '2024-07-10'),
(127, '414', 'HMG', '3', '100ml', 'Injection', '2024-07-10'),
(128, '419', 'CLOMIPHENE CITRATE', '3 times a day', '150 ml', 'Injection', '2024-07-26'),
(129, '426', 'CLOMIPHENE CITRATE', '3', '200 mg', 'Oral', '2024-07-26');

-- --------------------------------------------------------

--
-- Table structure for table `signup`
--

CREATE TABLE `signup` (
  `id` int(11) NOT NULL,
  `role` varchar(10) NOT NULL,
  `Userid` varchar(14) NOT NULL,
  `Password` varchar(15) NOT NULL,
  `reenterpassword` varchar(22) NOT NULL,
  `FirstName` varchar(20) NOT NULL,
  `Email` varchar(30) NOT NULL,
  `PhoneNumber` bigint(11) NOT NULL,
  `specification` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `update`
--

CREATE TABLE `update` (
  `id` int(11) NOT NULL,
  `Userid` int(11) NOT NULL,
  `Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `uploadimage`
--

CREATE TABLE `uploadimage` (
  `id` int(11) NOT NULL,
  `Userid` int(20) NOT NULL,
  `image` varchar(50) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `uploadimage`
--

INSERT INTO `uploadimage` (`id`, `Userid`, `image`, `date`) VALUES
(116, 360, 'videos/img_65ea8919135ef5.68514492.jpg', '2024-03-08'),
(119, 360, 'videos/img_65d2fac82eaa46.61598299.jpeg', '2024-04-10'),
(120, 365, 'videos/img_65d2fac82eaa46.61598299.jpeg', '2024-04-12'),
(122, 222, 'videos/img_6620d54b1456d9.50118241.jpg', '2024-04-18'),
(124, 219, 'videos/img_6622087192db77.99967601.jpg', '2024-04-19'),
(125, 222, 'videos/img_662258ead17126.71807644.jpg', '2024-04-19'),
(128, 222, 'videos/img_66225b363b2208.72512441.jpg', '2024-04-19'),
(129, 210, 'videos/img_66225b5e2f9ba2.94271619.jpg', '2024-04-19'),
(131, 374, 'videos/img_662783434d49a0.90296451.jpg', '2024-04-23'),
(140, 365, 'videos/img_6666d08e57d457.84909578.jpg', '2024-06-10'),
(141, 392, 'videos/img_6666d434851663.92939441.jpg', '2024-06-10'),
(143, 382, 'videos/img_666d852a266f25.77099290.jpg', '2024-06-15'),
(144, 382, 'videos/img_666d857432ab87.30987925.jpg', '2024-06-15'),
(145, 392, 'videos/img_666d86673ebf68.93633230.png', '2024-06-15'),
(146, 392, 'videos/img_666d8673bdcc83.18704502.jpg', '2024-06-15'),
(147, 374, 'videos/img_666d917bc2d8d1.20080213.jpg', '2024-06-15'),
(148, 374, 'videos/img_666d919b145dc2.50339386.jpg', '2024-06-15'),
(149, 374, 'videos/img_666d9296622817.18858445.jpg', '2024-06-15'),
(150, 393, 'videos/img_666d9306edb411.30253618.jpg', '2024-06-15'),
(151, 384, 'videos/img_6673f06c0069d7.30875918.jpg', '2024-06-20'),
(152, 392, 'videos/img_6688d387bfd089.73699152.jpg', '2024-07-06'),
(153, 387, 'videos/img_6688d9e5bebf76.43293451.jpg', '2024-07-06'),
(154, 387, 'videos/img_6688db0f9637c2.45294640.jpg', '2024-07-06'),
(155, 384, 'videos/img_6688dc4a928d60.68830822.jpg', '2024-07-06'),
(156, 393, 'videos/img_668904998fa225.11638717.jpg', '2024-07-06'),
(157, 393, 'videos/img_668904a505d603.00256385.jpg', '2024-07-06'),
(163, 414, 'videos/img_669165f5806db0.50612355.jpg', '2024-07-12'),
(166, 419, 'videos/img_6698d48aa07af0.11221342.jpg', '2024-07-18'),
(169, 426, 'videos/img_66a7c0098cc585.86195326.jpg', '2024-07-29'),
(171, 426, 'videos/img_671bbd0b1620f0.98348795.jpg', '2024-10-25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addpatient`
--
ALTER TABLE `addpatient`
  ADD PRIMARY KEY (`Userid`);

--
-- Indexes for table `addreport`
--
ALTER TABLE `addreport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `addspouse`
--
ALTER TABLE `addspouse`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `advices`
--
ALTER TABLE `advices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cycleupdate`
--
ALTER TABLE `cycleupdate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cycleupdate2`
--
ALTER TABLE `cycleupdate2`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `datep`
--
ALTER TABLE `datep`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `degignation`
--
ALTER TABLE `degignation`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctor_profile`
--
ALTER TABLE `doctor_profile`
  ADD PRIMARY KEY (`dr_userid`);

--
-- Indexes for table `medicationdetails`
--
ALTER TABLE `medicationdetails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `signup`
--
ALTER TABLE `signup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `update`
--
ALTER TABLE `update`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uploadimage`
--
ALTER TABLE `uploadimage`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addpatient`
--
ALTER TABLE `addpatient`
  MODIFY `Userid` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=436;

--
-- AUTO_INCREMENT for table `addreport`
--
ALTER TABLE `addreport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `addspouse`
--
ALTER TABLE `addspouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `advices`
--
ALTER TABLE `advices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `cycleupdate`
--
ALTER TABLE `cycleupdate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `datep`
--
ALTER TABLE `datep`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `degignation`
--
ALTER TABLE `degignation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `doctor_profile`
--
ALTER TABLE `doctor_profile`
  MODIFY `dr_userid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=192011482;

--
-- AUTO_INCREMENT for table `medicationdetails`
--
ALTER TABLE `medicationdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT for table `signup`
--
ALTER TABLE `signup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `update`
--
ALTER TABLE `update`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `uploadimage`
--
ALTER TABLE `uploadimage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
