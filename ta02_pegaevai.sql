-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 04:55 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ta02_pegaevai`
--

-- --------------------------------------------------------

--
-- Table structure for table `local`
--

CREATE TABLE `local` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `local`
--

INSERT INTO `local` (`id`, `nome`) VALUES
(1, 'Porto'),
(2, 'Braga'),
(3, 'Coimbra');

-- --------------------------------------------------------

--
-- Table structure for table `maquina`
--

CREATE TABLE `maquina` (
  `codigo` int(11) NOT NULL,
  `dataUltimaManut` datetime DEFAULT NULL,
  `idLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maquina`
--

INSERT INTO `maquina` (`codigo`, `dataUltimaManut`, `idLocal`) VALUES
(1, '2024-07-24 15:45:00', 1),
(2, '2023-12-31 23:59:59', 2),
(3, '2023-03-01 03:02:22', 3);

-- --------------------------------------------------------

--
-- Table structure for table `maquina_produto`
--

CREATE TABLE `maquina_produto` (
  `codMaquina` int(11) NOT NULL,
  `idProduto` int(11) NOT NULL,
  `valorUnidade` decimal(9,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maquina_produto`
--

INSERT INTO `maquina_produto` (`codMaquina`, `idProduto`, `valorUnidade`, `stock`) VALUES
(1, 1, 1.70, 4),
(2, 2, 2.50, 3),
(3, 3, 0.20, 9);

-- --------------------------------------------------------

--
-- Table structure for table `metododepagamento`
--

CREATE TABLE `metododepagamento` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `produto`
--

CREATE TABLE `produto` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `idTipo` int(11) DEFAULT NULL,
  `refrigerado` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produto`
--

INSERT INTO `produto` (`id`, `nome`, `idTipo`, `refrigerado`) VALUES
(1, 'Sumo de laranja', 1, b'1'),
(2, 'Baba de camelo', 2, b'1'),
(3, 'Colher de plastico', 3, b'0');

-- --------------------------------------------------------

--
-- Table structure for table `tipoproduto`
--

CREATE TABLE `tipoproduto` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipoproduto`
--

INSERT INTO `tipoproduto` (`id`, `nome`) VALUES
(1, 'Bebida'),
(2, 'Comida'),
(3, 'Utensilios');

-- --------------------------------------------------------

--
-- Table structure for table `venda`
--

CREATE TABLE `venda` (
  `codMaquina` int(11) NOT NULL,
  `idProduto` int(11) NOT NULL,
  `valor` decimal(11,2) DEFAULT NULL,
  `dataHora` datetime NOT NULL,
  `idMetodoPagamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `local`
--
ALTER TABLE `local`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maquina`
--
ALTER TABLE `maquina`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `FK_Maquina_local` (`idLocal`);

--
-- Indexes for table `maquina_produto`
--
ALTER TABLE `maquina_produto`
  ADD PRIMARY KEY (`codMaquina`,`idProduto`),
  ADD KEY `FK_Maquina_Produto_Produto` (`idProduto`);

--
-- Indexes for table `metododepagamento`
--
ALTER TABLE `metododepagamento`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_Produto_TipoProduto` (`idTipo`);

--
-- Indexes for table `tipoproduto`
--
ALTER TABLE `tipoproduto`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`codMaquina`,`idProduto`,`dataHora`),
  ADD KEY `FK_Venda_Produto` (`idProduto`),
  ADD KEY `FK_Venda_MetodoDePagamento` (`idMetodoPagamento`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `local`
--
ALTER TABLE `local`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `maquina`
--
ALTER TABLE `maquina`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `metododepagamento`
--
ALTER TABLE `metododepagamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `produto`
--
ALTER TABLE `produto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tipoproduto`
--
ALTER TABLE `tipoproduto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `maquina`
--
ALTER TABLE `maquina`
  ADD CONSTRAINT `FK_Maquina_local` FOREIGN KEY (`idLocal`) REFERENCES `local` (`id`);

--
-- Constraints for table `maquina_produto`
--
ALTER TABLE `maquina_produto`
  ADD CONSTRAINT `FK_Maquina_Produto_Maquina` FOREIGN KEY (`codMaquina`) REFERENCES `maquina` (`codigo`),
  ADD CONSTRAINT `FK_Maquina_Produto_Produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`id`);

--
-- Constraints for table `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `FK_Produto_TipoProduto` FOREIGN KEY (`idTipo`) REFERENCES `tipoproduto` (`id`);

--
-- Constraints for table `venda`
--
ALTER TABLE `venda`
  ADD CONSTRAINT `FK_Venda_Maquina` FOREIGN KEY (`codMaquina`) REFERENCES `maquina` (`codigo`),
  ADD CONSTRAINT `FK_Venda_MetodoDePagamento` FOREIGN KEY (`idMetodoPagamento`) REFERENCES `metododepagamento` (`id`),
  ADD CONSTRAINT `FK_Venda_Produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
