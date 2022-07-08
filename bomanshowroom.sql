-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.33 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for showroom
CREATE DATABASE IF NOT EXISTS `showroom` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `showroom`;

-- Dumping structure for table showroom.admin
CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table showroom.tb_databarang
CREATE TABLE IF NOT EXISTS `tb_databarang` (
  `kode_barang` int(50) NOT NULL AUTO_INCREMENT,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `stok` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `jenis` varchar(50) DEFAULT NULL,
  `merk` varchar(50) DEFAULT NULL,
  `warna` varchar(50) DEFAULT NULL,
  `tahun` int(11) DEFAULT NULL,
  `bahan_bakar` varchar(50) DEFAULT NULL,
  `transmisi` varchar(50) DEFAULT NULL,
  `mesin` varchar(50) DEFAULT NULL,
  `ukuran_ban` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kode_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=2035 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table showroom.tb_datapetugas
CREATE TABLE IF NOT EXISTS `tb_datapetugas` (
  `id_petugas` int(11) NOT NULL AUTO_INCREMENT,
  `nama_petugas` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `tanggal_pendaftaran` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`id_petugas`)
) ENGINE=InnoDB AUTO_INCREMENT=1008 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table showroom.tb_keranjang
CREATE TABLE IF NOT EXISTS `tb_keranjang` (
  `id_transaksi` int(11) NOT NULL AUTO_INCREMENT,
  `kode_barang` int(10) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `total_harga` int(10) NOT NULL,
  `tgl_transaksi` date NOT NULL,
  PRIMARY KEY (`id_transaksi`),
  KEY `kode_barang` (`kode_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for procedure showroom.total_harga_transaksi
DELIMITER //
CREATE PROCEDURE `total_harga_transaksi`()
BEGIN
SELECT 
SUM(tb_keranjang.jumlah*tb_keranjang.harga) AS total_harga
FROM tb_keranjang;
END//
DELIMITER ;

-- Dumping structure for table showroom.transaksi
CREATE TABLE IF NOT EXISTS `transaksi` (
  `tgl_transaksi` date NOT NULL,
  `id_transaksi` int(11) NOT NULL AUTO_INCREMENT,
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah_barang` int(10) NOT NULL,
  `total_harga` int(11) NOT NULL,
  PRIMARY KEY (`id_transaksi`),
  KEY `kode_barang` (`kode_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for trigger showroom.cancel
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `cancel` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok + OLD.jumlah
WHERE kode_barang = OLD.kode_barang;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger showroom.cancel_2
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `cancel_2` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM transaksi
WHERE kode_barang = OLD.kode_barang;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger showroom.keranjang
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `keranjang` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
INSERT INTO tb_keranjang SET
id_transaksi = NEW.id_transaksi,
kode_barang = NEW.kode_barang,
nama_barang = NEW.nama_barang,
harga = NEW.harga,
jumlah = NEW.jumlah_barang,
total_harga = NEW.total_harga,
tgl_transaksi = NEW.tgl_transaksi;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger showroom.stok_habis
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `stok_habis` AFTER INSERT ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM tb_databarang
WHERE stok = 0
AND
kode_barang = NEW.kode_barang;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger showroom.transaksi
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok - NEW.jumlah_barang
WHERE kode_barang = NEW.kode_barang;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
