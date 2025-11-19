--Hapus Database TokoRetailDB yang sudah ada
IF DB_ID('TokoRetailDB') IS NOT NULL
BEGIN
	USE master; 
	DROP DATABASE TokoRetailDB;
END
GO

--Buat Database baru
CREATE DATABASE TokoRetailDB
GO


--Menggunakan TokoRetailDB
USE TokoRetailDB
GO

--Membuat Table KategoriProduk
CREATE TABLE KategoriProduk(
	KategoriID INT IDENTITY(1, 1) PRIMARY KEY, 
	NamaKategori VARCHAR(100) NOT NULL UNIQUE
);
GO

DROP TABLE KategoriProduk;
GO

--Membuat Table Produk
CREATE TABLE Produk(
	ProdukID INT IDENTITY(1001, 1) PRIMARY KEY,
	SKU VARCHAR(20) NOT NULL UNIQUE,
	NamaProduk VARCHAR(150) NOT NULL,
	Harga DECIMAL(10,2) NOT NULL,
	Stock INT NOT NULL,
	KategoriID INT NULL,

	--Cara Menulis Constraint
	CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0),
	CONSTRAINT CHK_StockPositif CHECK (Stock >= 0),
	CONSTRAINT FK_Produk_Kategori 
	FOREIGN KEY (KategoriID)
	REFERENCES KategoriProduk (KategoriID)
);
GO

--Membuat Table Pelanggan
CREATE TABLE Pelanggan (
	PelangganID INT IDENTITY(1,1) PRIMARY KEY,
	NamaDepan VARCHAR(50) NOT NULL, 
	NamaBelakang VARCHAR(50) NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	NoTelepon VARCHAR(20) NULL,
	TanggalDaftar DATE DEFAULT GETDATE()
);
GO

--Membuat PesananHeader
CREATE TABLE PesananHeader (
	PesananID INT IDENTITY(5001,1) PRIMARY KEY,
	PelangganID INT NOT NULL,
	TanggalPesanan DATETIME2 DEFAULT GETDATE(),
	StatusPesanan VARCHAR(20) NOT NULL,

	CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN('Baru','Proses','Selesai','Batal')),
	CONSTRAINT FK_Pesanan_Pelanggan
	FOREIGN KEY (PelangganID)
	REFERENCES Pelanggan(PelangganID)
);
GO

--Membuat Table Pesanan Detail
CREATE TABLE PesananDetail(
	PesananDetailID INT IDENTITY(1,1) PRIMARY KEY,
	PesananID INT NOT NULL,
	ProdukID INT NOT NULL,
	Jumlah INT NOT NULL,
	HargaSatuan DECIMAL (10,2) NOT NULL,

	CONSTRAINT CHK_JumlahPositif CHECK (Jumlah>0),
	--FK PesananDetail & PesananHeader
	CONSTRAINT FK_Detail_Header
	FOREIGN KEY (PesananID)
	REFERENCES PesananHeader(PesananID)
	ON DELETE CASCADE, --Jika Header dihapus, detail juga ikut terhapus

	CONSTRAINT FK_Detail_Produk
		FOREIGN KEY (ProdukID)
		REFERENCES Produk (ProdukID)
);
GO

--Menambah Data ke Tabel Pelanggan
INSERT INTO Pelanggan(NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES
('Budi', 'Santoso', 'BudiSantoso@gmail.com','09208398'),
('Rizky', 'Putra', 'RizkyGantnk@gmail.com',NULL);

--Verifikasi Data
PRINT 'Data Pelanggan:';
SELECT * FROM Pelanggan

INSERT INTO KategoriProduk(NamaKategori)
VALUES ('Elektronik'), ('Buku'), ('Pakaian');

PRINT 'Data Kategori:';
SELECT * FROM KategoriProduk;

--Menambah Data Ke tabel Produk
INSERT INTO Produk (SKU, NamaProduk, Harga, Stock, KategoriID)
VALUES
('Elec-001', 'Laptop Pro', 15000000.00, 50, 1),
('PAK-001', 'Kaus Putih', 7000000.00, 50, 1);


--Mencoba Pelanggaran Unique
INSERT INTO Pelanggan (NamaDepan, Email)
Values (Budii


