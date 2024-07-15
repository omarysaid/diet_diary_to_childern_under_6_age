-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 26, 2024 at 11:13 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dietdiary_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `diet`
--

CREATE TABLE `diet` (
  `diet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `from_age` varchar(50) NOT NULL,
  `to_age` varchar(50) NOT NULL,
  `from_weight` varchar(50) NOT NULL,
  `to_weight` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(500) NOT NULL,
  `image` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diet`
--

INSERT INTO `diet` (`diet_id`, `user_id`, `from_age`, `to_age`, `from_weight`, `to_weight`, `name`, `description`, `image`, `created_at`) VALUES
(43, 7, '0', '0.9', '12', '24', 'Protein', 'In general, Europeans eat enough protein and deficiency is rare among most developed countries (figure 3).  As the diet of Europeans already exceeds the required level, EFSA has not recommended an increase in current protein intakes.1', '1000094575.jpg', '2024-06-26 03:05:47'),
(44, 7, '0', '0.9', '1', '10', 'Protein', 'In general, Europeans eat enough protein and deficiency is rare among most developed countries (figure 3).  As the diet of Europeans already exceeds the required level, EFSA has not recommended an increase in current protein intakes.', '1000094570.jpg', '2024-06-26 03:05:57'),
(54, 7, '1', '2', '10', '20', 'Protein', 'The important food diet for the children\n', '1000094566.jpg', '2024-06-26 03:06:06'),
(58, 12, '20', '30', '100', '500', 'fatsjoe', 'fats for better foods', '1000010040.jpg', '2024-06-26 23:53:11'),
(63, 17, '1', '7', '100', '200', 'protein ', 'bshz djsz jsjzz bsjzz nsjs', '1000010208.jpg', '2024-06-26 23:54:56'),
(64, 17, '10', '30', '200', '300', 'Fats', 'hhs jsks jsjs jsjs', '1000010410.jpg', '2024-06-26 23:55:36'),
(65, 23, '10', '20', '100', '300', 'Protein ', 'hsj sis sjsjs jsis nsis sjs wis', '1000010036.jpg', '2024-06-26 23:58:34'),
(66, 23, '30', '40', '20', '39', 'protein ', 'sjjs jsjs sjss sjs sjssj', '1000010186.jpg', '2024-06-26 23:59:29'),
(67, 7, '10', '40', '100', '400', 'protein ', 'fgg h h hhh hhh hhh hhj hhh hhjhh ', '1000009885.jpg', '2024-06-27 00:06:52'),
(68, 7, '67', '79', '67', '88', 'protein ', 'hfgh bhh hh hhgh jhhv hghhj ', '1000008201.jpg', '2024-06-27 00:10:54');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `role_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(300) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`role_id`, `name`, `description`, `created_at`) VALUES
(1, 'nutritionalist', 'Manage diets details', '2024-05-20 00:39:57'),
(2, 'NormalUsers', 'viewing diets details', '2024-06-25 00:53:31');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `phone`, `password`, `role`, `created_at`) VALUES
(7, 'Esther', '0672488849', 'e10adc3949ba59abbe56e057f20f883e', 'Nutritionist', '2024-06-05 12:59:27'),
(11, 'Kaka', '0987976797 ', 'fcea920f7412b5da7be0cf42b8c93759', 'Nutritionist', '2024-06-23 19:16:03'),
(12, 'koko', '097272000', 'fcea920f7412b5da7be0cf42b8c93759', 'Nutritionist', '2024-06-23 19:34:16'),
(13, 'Helman', '0868665865', '670b14728ad9902aecba32e22fa4f6bd', 'Nutritionist', '2024-06-23 19:16:20'),
(14, 'Minna', '0987987657', 'fcea920f7412b5da7be0cf42b8c93759', 'Nutritionist', '2024-06-23 19:16:29'),
(17, 'Anna', '0787676543', 'e10adc3949ba59abbe56e057f20f883e', 'Nutritionist', '2024-06-05 13:01:31'),
(22, 'jj', '0897668755', '670b14728ad9902aecba32e22fa4f6bd', 'NormalUser', '2024-06-24 22:00:36'),
(23, 'Hafsa', '0678767654', 'e10adc3949ba59abbe56e057f20f883e', 'Nutritionist', '2024-06-26 20:57:42'),
(24, 'ww', '222', '30e535568de1f9231e7d9df0f4a5a44d', 'Nutritionist', '2024-06-25 00:18:56'),
(25, 'Anna', '0789879876', 'e10adc3949ba59abbe56e057f20f883e', 'Nutritionist', '2024-06-26 20:52:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `diet`
--
ALTER TABLE `diet`
  ADD PRIMARY KEY (`diet_id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `diet`
--
ALTER TABLE `diet`
  MODIFY `diet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
