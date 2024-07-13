-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 13, 2024 at 02:05 PM
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
-- Database: `perpus_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetJudulBuku` (IN `penulis_id` INT, IN `genre_id` INT)   BEGIN
    DECLARE judul VARCHAR(100);
    
    SELECT judul INTO judul
    FROM Buku
    WHERE id_penulis = penulis_id AND id_genre = genre_id;
    
    IF judul IS NOT NULL THEN
        SELECT CONCAT('Judul buku: ', judul) AS Result;
    ELSE
        SELECT 'Buku tidak ditemukan.' AS Result;
    END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampilkanSemuaBuku` ()   BEGIN
    SELECT * FROM Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTahunTerbitBuku` (IN `judul_buku` VARCHAR(100), IN `tahun_terbit_baru` DATE)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id_buku INT;
    DECLARE cur CURSOR FOR SELECT id_buku FROM Buku WHERE judul = judul_buku;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO id_buku;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update tahun terbit buku
        UPDATE Buku SET tanggal_terbit = tahun_terbit_baru WHERE id_buku = id_buku;
    END LOOP;
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTanggalKembali` (`id_peminjaman` INT, `tanggal_kembali` DATE)   BEGIN
    UPDATE Peminjaman
    SET tanggal_kembali = tanggal_kembali
    WHERE id_peminjaman = id_peminjaman;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getNamaPenulis` (`id_penulis` INT, `id_buku` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE nama_penulis VARCHAR(100);
    SELECT p.nama INTO nama_penulis
    FROM Penulis p
    JOIN Buku b ON p.id_penulis = b.id_penulis
    WHERE p.id_penulis = id_penulis AND b.id_buku = id_buku;
    RETURN nama_penulis;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitungJumlahBuku` () RETURNS INT(11)  BEGIN
    DECLARE jumlah INT;
    SELECT COUNT(*) INTO jumlah FROM Buku;
    RETURN jumlah;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `anggota`
--

CREATE TABLE `anggota` (
  `id_anggota` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `tanggal_keanggotaan` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `anggota`
--

INSERT INTO `anggota` (`id_anggota`, `nama`, `email`, `telepon`, `tanggal_keanggotaan`) VALUES
(1, 'Havid', 'Havid@gmail.com', '1234567890', '2024-01-01'),
(2, 'Fattaah', 'fattaah@gmail.com', '0987654321', '2024-02-15'),
(3, 'Wildan', 'Widan@gmail.com', '1122334455', '2024-03-10'),
(4, 'Willie', 'Willie@gmail.com', '3344556677', '2024-05-20'),
(5, 'Havid', 'Havid@gmail.com', '1234567890', '2024-01-01'),
(6, 'Fattaah', 'fattaah@gmail.com', '0987654321', '2024-02-15'),
(7, 'Wildan', 'Widan@gmail.com', '1122334455', '2024-03-10'),
(8, 'Willie', 'Willie@gmail.com', '3344556677', '2024-05-20');

--
-- Triggers `anggota`
--
DELIMITER $$
CREATE TRIGGER `before_update_anggota` BEFORE UPDATE ON `anggota` FOR EACH ROW BEGIN
    DECLARE email_count INT;

    IF NEW.email <> OLD.email THEN
        SELECT COUNT(*) INTO email_count FROM Anggota WHERE email = NEW.email;
        IF email_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email sudah digunakan oleh anggota lain';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `id_penulis` int(11) DEFAULT NULL,
  `id_genre` int(11) DEFAULT NULL,
  `tanggal_terbit` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `id_penulis`, `id_genre`, `tanggal_terbit`) VALUES
(1, 'Cinta Itu Luka', 1, 1, '2002-01-01'),
(2, 'Filosofi Teras', 2, 1, '2018-11-26'),
(3, 'Hujan Bulan Juni', 3, 1, '2015-06-14'),
(4, 'Sejarah Dunia Kuno', 4, 1, '2007-03-06'),
(5, 'Bumi Manusia', 5, 4, '1980-01-01'),
(6, 'Cinta Itu Luka', 1, 1, '2002-01-01'),
(7, 'Filosofi Teras', 2, 1, '2018-11-26'),
(8, 'Hujan Bulan Juni', 3, 1, '2015-06-14'),
(9, 'Sejarah Dunia Kuno', 4, 1, '2007-03-06'),
(10, 'Bumi Manusia', 5, 4, '1980-01-01'),
(11, 'Buku Baru', 1, 1, '2024-07-13');

--
-- Triggers `buku`
--
DELIMITER $$
CREATE TRIGGER `after_update_buku` AFTER UPDATE ON `buku` FOR EACH ROW BEGIN
    IF NEW.judul <> OLD.judul THEN
        INSERT INTO Buku_Log (id_buku, judul_lama, judul_baru, waktu_perubahan, tipe_perubahan)
        VALUES (NEW.id_buku, OLD.judul, NEW.judul, NOW(), 'UPDATE');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_buku` BEFORE INSERT ON `buku` FOR EACH ROW BEGIN
    DECLARE penulis_count INT;
    DECLARE genre_count INT;

    SELECT COUNT(*) INTO penulis_count FROM Penulis WHERE id_penulis = NEW.id_penulis;
    SELECT COUNT(*) INTO genre_count FROM Genre WHERE id_genre = NEW.id_genre;

    IF penulis_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Penulis tidak valid';
    END IF;

    IF genre_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Genre tidak valid';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `bukuekakurniawan`
-- (See below for the actual view)
--
CREATE TABLE `bukuekakurniawan` (
`judul` varchar(100)
,`tanggal_terbit` date
,`nama` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `bukusetelah2000`
-- (See below for the actual view)
--
CREATE TABLE `bukusetelah2000` (
`id_buku` int(11)
,`judul` varchar(100)
,`id_penulis` int(11)
,`id_genre` int(11)
,`tanggal_terbit` date
);

-- --------------------------------------------------------

--
-- Table structure for table `genre`
--

CREATE TABLE `genre` (
  `id_genre` int(11) NOT NULL,
  `nama_genre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `genre`
--

INSERT INTO `genre` (`id_genre`, `nama_genre`) VALUES
(1, 'Fiksi'),
(2, 'Non-Fiksi'),
(3, 'Puisi'),
(4, 'Sejarah'),
(5, 'Biografi'),
(6, 'Fiksi'),
(7, 'Non-Fiksi'),
(8, 'Puisi'),
(9, 'Sejarah'),
(10, 'Biografi');

--
-- Triggers `genre`
--
DELIMITER $$
CREATE TRIGGER `after_delete_genre` AFTER DELETE ON `genre` FOR EACH ROW BEGIN
    INSERT INTO Genre_Log (id_genre, nama_genre, waktu_hapus)
    VALUES (OLD.id_genre, OLD.nama_genre, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `infokontakanggota`
-- (See below for the actual view)
--
CREATE TABLE `infokontakanggota` (
`nama` varchar(100)
,`email` varchar(100)
,`telepon` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `id_anggota` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_buku`, `id_anggota`, `tanggal_pinjam`, `tanggal_kembali`) VALUES
(6, 1, 1, '2024-06-01', '2024-07-10'),
(7, 2, 2, '2024-06-05', '2024-07-10'),
(8, 3, 3, '2024-06-10', '2024-07-10'),
(9, 4, 4, '2024-06-15', '2024-07-10');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `after_insert_peminjaman` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    INSERT INTO Peminjaman_Log (id_peminjaman, id_buku, id_anggota, tanggal_pinjam, tanggal_kembali, waktu_transaksi, tipe_transaksi)
    VALUES (NEW.id_peminjaman, NEW.id_buku, NEW.id_anggota, NEW.tanggal_pinjam, NEW.tanggal_kembali, NOW(), 'INSERT');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `penulis`
--

CREATE TABLE `penulis` (
  `id_penulis` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penulis`
--

INSERT INTO `penulis` (`id_penulis`, `nama`, `tanggal_lahir`) VALUES
(1, 'Eka Kurniawan', '1975-11-28'),
(2, 'Henry Manampiring', '1983-05-30'),
(3, 'Sapardi Djoko Damono', '1940-03-20'),
(4, 'Susan Wise Bauer', '1968-08-08'),
(5, 'Pramoedya Ananta Toer', '1925-02-06'),
(6, 'Eka Kurniawan', '1975-11-28'),
(7, 'Henry Manampiring', '1983-05-30'),
(8, 'Sapardi Djoko Damono', '1940-03-20'),
(9, 'Susan Wise Bauer', '1968-08-08'),
(10, 'Pramoedya Ananta Toer', '1925-02-06');

--
-- Triggers `penulis`
--
DELIMITER $$
CREATE TRIGGER `before_delete_penulis` BEFORE DELETE ON `penulis` FOR EACH ROW BEGIN
    DECLARE buku_count INT;

    SELECT COUNT(*) INTO buku_count FROM Buku WHERE id_penulis = OLD.id_penulis;
    IF buku_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Penulis memiliki buku yang masih tersimpan';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pinjam`
--

CREATE TABLE `pinjam` (
  `id_peminjaman` int(11) NOT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `id_anggota` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `bukuekakurniawan`
--
DROP TABLE IF EXISTS `bukuekakurniawan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bukuekakurniawan`  AS SELECT `buku`.`judul` AS `judul`, `buku`.`tanggal_terbit` AS `tanggal_terbit`, `penulis`.`nama` AS `nama` FROM (`buku` join `penulis` on(`buku`.`id_penulis` = `penulis`.`id_penulis`)) WHERE `penulis`.`nama` = 'Eka Kurniawan'WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `bukusetelah2000`
--
DROP TABLE IF EXISTS `bukusetelah2000`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bukusetelah2000`  AS SELECT `buku`.`id_buku` AS `id_buku`, `buku`.`judul` AS `judul`, `buku`.`id_penulis` AS `id_penulis`, `buku`.`id_genre` AS `id_genre`, `buku`.`tanggal_terbit` AS `tanggal_terbit` FROM `buku` WHERE `buku`.`tanggal_terbit` > '2000-01-01' ;

-- --------------------------------------------------------

--
-- Structure for view `infokontakanggota`
--
DROP TABLE IF EXISTS `infokontakanggota`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `infokontakanggota`  AS SELECT `anggota`.`nama` AS `nama`, `anggota`.`email` AS `email`, `anggota`.`telepon` AS `telepon` FROM `anggota` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anggota`
--
ALTER TABLE `anggota`
  ADD PRIMARY KEY (`id_anggota`),
  ADD KEY `idx_nama_telepon` (`nama`,`telepon`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`),
  ADD KEY `id_genre` (`id_genre`),
  ADD KEY `idx_penulis_genre` (`id_penulis`,`id_genre`);

--
-- Indexes for table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`id_genre`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_buku` (`id_buku`),
  ADD KEY `id_anggota` (`id_anggota`);

--
-- Indexes for table `penulis`
--
ALTER TABLE `penulis`
  ADD PRIMARY KEY (`id_penulis`);

--
-- Indexes for table `pinjam`
--
ALTER TABLE `pinjam`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_anggota` (`id_anggota`),
  ADD KEY `idx_buku_anggota` (`id_buku`,`id_anggota`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `anggota`
--
ALTER TABLE `anggota`
  MODIFY `id_anggota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `genre`
--
ALTER TABLE `genre`
  MODIFY `id_genre` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `penulis`
--
ALTER TABLE `penulis`
  MODIFY `id_penulis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pinjam`
--
ALTER TABLE `pinjam`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `buku`
--
ALTER TABLE `buku`
  ADD CONSTRAINT `buku_ibfk_1` FOREIGN KEY (`id_penulis`) REFERENCES `penulis` (`id_penulis`),
  ADD CONSTRAINT `buku_ibfk_2` FOREIGN KEY (`id_genre`) REFERENCES `genre` (`id_genre`);

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_anggota`) REFERENCES `anggota` (`id_anggota`);

--
-- Constraints for table `pinjam`
--
ALTER TABLE `pinjam`
  ADD CONSTRAINT `pinjam_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `pinjam_ibfk_2` FOREIGN KEY (`id_anggota`) REFERENCES `anggota` (`id_anggota`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
