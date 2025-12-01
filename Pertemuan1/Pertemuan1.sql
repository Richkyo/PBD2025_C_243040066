CREATE DATABASE TokoRetailDB;
USE TokoRetailDB;

CREATE TABLE Produk  ( 
ProdukID INT, 
SKU VARCHAR(15), 
NamaProduk VARCHAR(100), 
Harga DECIMAL(10, 2), 
Stok INT 
);

-- Cek struktur tabel (Opsional) 
EXEC sp_help 'Produk';


-- Table Pelanggan
CREATE TABLE Pelanggan ( 
    -- IDENTITY(1,1) adalah sintaks SQL Server untuk auto-increment 
    -- Dimulai dari 1, bertambah 1 setiap ada data baru. 
    PelangganID INT IDENTITY(1,1) PRIMARY KEY, 
     
    NamaDepan VARCHAR(50) NOT NULL, 
    NamaBelakang VARCHAR(50) NULL, 
     
    Email VARCHAR(100) NOT NULL UNIQUE, 
     
    TanggalDaftar DATE DEFAULT GETDATE() 
);

-- Cek struktur dan constraint 
EXEC sp_help 'Pelanggan'; 

-- Table Pesanan
CREATE TABLE PesananHeader  ( 
    PesananID INT IDENTITY(1,1) PRIMARY KEY, 
     
    TanggalPesanan DATETIME2 NOT NULL, 
     
    -- Ini adalah kolom Foreign Key 
    PelangganID INT NOT NULL, 
     
    StatusPesanan VARCHAR(10) NOT NULL, 
     
    -- Mendefinisikan constraint FOREIGN KEY (out-of-line) 
CONSTRAINT FK_Pesanan_Pelanggan 
FOREIGN KEY (PelangganID)  
REFERENCES Pelanggan(PelangganID), 
-- Mendefinisikan constraint CHECK 
CONSTRAINT CHK_StatusPesanan 
CHECK (StatusPesanan IN ('Baru', 'Proses', 'Selesai')) 
); 
-- Cek relasi 
EXEC sp_help 'PesananHeader';

-- Modifikasi Struktur
-- 1. Menambahkan Primary Key ke tabel Produk -- (Kita asumsikan ProdukID sudah diisi data unik dan NOT NULL, --  tapi karena tabel kita masih kosong, kita tambahkan NOT NULL dulu) 
ALTER TABLE Produk 
ALTER COLUMN ProdukID INT NOT NULL; 
GO 
ALTER TABLE Produk 
ADD CONSTRAINT PK_Produk PRIMARY KEY (ProdukID); 
GO -- 2. Menambahkan kolom NoTelepon ke tabel Pelanggan 
ALTER TABLE Pelanggan 
ADD NoTelepon VARCHAR(20) NULL; 
GO -- 3. Mengubah kolom Harga di Produk agar wajib diisi 
ALTER TABLE Produk 
ALTER COLUMN Harga DECIMAL(10, 2) NOT NULL; 
GO 
-- Cek struktur kedua tabel untuk melihat perubahan 
EXEC sp_help 'Produk'; 
EXEC sp_help 'Pelanggan'; 


-- Drop Table
-- 1. Buat tabel detail 
CREATE TABLE PesananDetail ( 
    PesananDetailID INT IDENTITY(1,1) PRIMARY KEY, 
    PesananID INT NOT NULL, 
    ProdukID INT NOT NULL, 
    Jumlah INT NOT NULL, 
     
    CONSTRAINT FK_Detail_Header  
    FOREIGN KEY (PesananID) REFERENCES PesananHeader(PesananID), 
     
    CONSTRAINT FK_Detail_Produk 
    FOREIGN KEY (ProdukID) REFERENCES Produk(ProdukID) 
); 
GO 

-- 2. Coba hapus tabel Pelanggan (GAGAL) 
PRINT 'Mencoba menghapus Pelanggan... (Harusnya Gagal)'; 
DROP TABLE Pelanggan; 
-- Pesan Error: "Could not drop object 'Pelanggan' because it is referenced by a FOREIGN KEY constraint 'FK_Pesanan_Pelanggan'." 
GO 
-- 3. Coba hapus tabel PesananHeader (GAGAL) 
PRINT 'Mencoba menghapus PesananHeader... (Harusnya Gagal)'; 
DROP TABLE PesananHeader;
-- Pesan Error: "Could not drop object 'PesananHeader' because it is referenced by a FOREIGN KEY constraint 'FK_Detail_Header'."
GO
-- 4. Hapus tabel secara berurutan (dari anak ke induk) 
PRINT 'Menghapus PesananDetail (tabel anak) terlebih dahulu...'; 
DROP TABLE PesananDetail; 
GO 

PRINT 'Menghapus PesananHeader (tabel induk dari detail) ...'; 
DROP TABLE PesananHeader; 
GO 
PRINT 'Menghapus Pelanggan (tabel induk dari header)...'; 
DROP TABLE Pelanggan; 
GO 
PRINT 'Semua tabel pesanan dan pelanggan berhasil dihapus.'; 
