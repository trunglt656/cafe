USE [QLCF]
GO
/****** Object:  User [admin]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [admin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NV02]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [NV02] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NV06]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [NV06] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NV07]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [NV07] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NV12]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [NV12] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NV14]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE USER [NV14] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [NV]    Script Date: 2/20/2025 3:59:16 PM ******/
CREATE ROLE [NV]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [admin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [admin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [admin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [admin]
GO
ALTER ROLE [db_owner] ADD MEMBER [NV02]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [NV02]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NV02]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NV02]
GO
ALTER ROLE [NV] ADD MEMBER [NV06]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NV06]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NV06]
GO
ALTER ROLE [NV] ADD MEMBER [NV07]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NV07]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NV07]
GO
ALTER ROLE [NV] ADD MEMBER [NV12]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NV12]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NV12]
GO
ALTER ROLE [NV] ADD MEMBER [NV14]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NV14]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NV14]
GO
/****** Object:  UserDefinedFunction [dbo].[Thang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Thang]()
RETURNS @Thang TABLE (so INT , chu NVARCHAR(3) )
AS
BEGIN
	INSERT INTO @Thang VALUES  ( 1, N'JAN')
	INSERT INTO @Thang VALUES  ( 2, N'FEB')
	INSERT INTO @Thang VALUES  ( 3, N'MAR')
	INSERT INTO @Thang VALUES  ( 4, N'APR')
	INSERT INTO @Thang VALUES  ( 5, N'MAY')
	INSERT INTO @Thang VALUES  ( 6, N'JUN')
	INSERT INTO @Thang VALUES  ( 7, N'JUL')
	INSERT INTO @Thang VALUES  ( 8, N'AUG')
	INSERT INTO @Thang VALUES  ( 9, N'SEP')
	INSERT INTO @Thang VALUES  ( 10, N'OCT')
	INSERT INTO @Thang VALUES  ( 11, N'NOV')
	INSERT INTO @Thang VALUES  ( 12, N'DEC')
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[UF_CheckLoaiNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_CheckLoaiNV]
(
@maNV nchar(4)
)
RETURNS int
AS
BEGIN
	DECLARE @kt INT;
	IF @maNV in (SELECT * FROM NVPHUCVU)
	SET @kt = 1;
	IF @maNV in (SELECT MaNV FROM NVTHUNGAN)
	SET @kt = 0;
	RETURN @kt;

END

GO
/****** Object:  UserDefinedFunction [dbo].[UF_Top5Mon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_Top5Mon]()
RETURNS @Top5Mon TABLE(TenMon NVARCHAR(30), SoLuong INT )
AS
BEGIN
	INSERT INTO @Top5Mon
	SELECT TOP 5 TenMon, SUM(SoLuong) AS SoLuong
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
		JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
	WHERE MONTH(NgayLap) = MONTH(GETDATE())
	GROUP BY TenMon
	ORDER BY SoLuong DESC

	DECLARE @soLuong INT
	SELECT @soLuong = SUM(Temp.SoLuong)
	FROM	(SELECT TenMon, SUM(SoLuong) AS SoLuong
			FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
				JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
			WHERE MONTH(NgayLap) = MONTH(GETDATE())
			GROUP BY TenMon
			ORDER BY SoLuong DESC
			OFFSET     5 ROWS) AS Temp

	INSERT INTO @Top5Mon
	VALUES  ( N'Các món còn lại', -- tenMon - nvarchar(30)
	          @soLuong  -- soLuong - int
	          )
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[UF_Top5Year]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UF_Top5Year]()
RETURNS @Top5Mon TABLE(TenMon NVARCHAR(30), SoLuong INT )
AS
BEGIN
	INSERT INTO @Top5Mon
	SELECT TOP 5 TenMon, SUM(SoLuong) AS SoLuong
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
		JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
	WHERE YEAR(NgayLap) = YEAR(GETDATE())
	GROUP BY TenMon
	ORDER BY SoLuong DESC

	DECLARE @soLuong INT
	SELECT @soLuong = SUM(Temp.SoLuong)
	FROM	(SELECT TenMon, SUM(SoLuong) AS SoLuong
			FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
				JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
			WHERE YEAR(NgayLap) = YEAR(GETDATE())
			GROUP BY TenMon
			ORDER BY SoLuong DESC
			OFFSET     5 ROWS) AS Temp

	INSERT INTO @Top5Mon
	VALUES  ( N'Các món còn lại', -- tenMon - nvarchar(30)
	          @soLuong  -- soLuong - int
	          )
	RETURN
END
GO
/****** Object:  Table [dbo].[BAN]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BAN](
	[MaBan] [nchar](4) NOT NULL,
	[TenBan] [nvarchar](50) NULL,
	[MaKhuVuc] [nchar](4) NOT NULL,
	[TrangThai] [nvarchar](30) NULL,
 CONSTRAINT [PK_BAN] PRIMARY KEY CLUSTERED 
(
	[MaBan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CTHOADON]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTHOADON](
	[MaHD] [int] NOT NULL,
	[MaMon] [nchar](4) NOT NULL,
	[SoLuong] [int] NULL,
	[ThanhTien] [money] NULL,
 CONSTRAINT [PK_CTHOADON] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CTPHIEUCHI]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTPHIEUCHI](
	[MaPC] [int] NOT NULL,
	[MaNC] [nchar](4) NOT NULL,
	[TongTien] [money] NULL,
 CONSTRAINT [PK_CTPHIEUCHI] PRIMARY KEY CLUSTERED 
(
	[MaPC] ASC,
	[MaNC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON](
	[MaHD] [int] IDENTITY(1,1) NOT NULL,
	[TongTien] [int] NULL,
	[NgayLap] [date] NULL,
	[MaNVTN] [nchar](4) NOT NULL,
	[MaBan] [nchar](4) NOT NULL,
	[TrangThai] [bit] NOT NULL,
 CONSTRAINT [PK_HOADON_1] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHUVUC]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHUVUC](
	[MaKhuVuc] [nchar](4) NOT NULL,
	[TenKhuVuc] [nvarchar](50) NULL,
	[PhuThu] [float] NULL,
 CONSTRAINT [PK_KHUVUC] PRIMARY KEY CLUSTERED 
(
	[MaKhuVuc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAIMON]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIMON](
	[MaLoaiMon] [nchar](4) NOT NULL,
	[TenLoaiMon] [nvarchar](50) NULL,
 CONSTRAINT [PK_LOAIMON] PRIMARY KEY CLUSTERED 
(
	[MaLoaiMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MON]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MON](
	[MaMon] [nchar](4) NOT NULL,
	[TenMon] [nvarchar](50) NULL,
	[MaLoaiMon] [nchar](4) NOT NULL,
	[GiaTien] [float] NULL,
 CONSTRAINT [PK_MON] PRIMARY KEY CLUSTERED 
(
	[MaMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MaNV] [nchar](4) NOT NULL,
	[TenNV] [nvarchar](50) NULL,
	[CMND] [nchar](10) NULL,
	[SoDT] [nchar](10) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[NgayVaoLam] [date] NULL,
 CONSTRAINT [PK_NHANVIEN] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHOMCHI]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHOMCHI](
	[MaNhomChi] [nchar](4) NOT NULL,
	[TenNhomChi] [nvarchar](50) NULL,
 CONSTRAINT [PK_NHOMCHI] PRIMARY KEY CLUSTERED 
(
	[MaNhomChi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NVPHUCVU]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVPHUCVU](
	[MaNV] [nchar](4) NOT NULL,
 CONSTRAINT [PK_NVPHUCVU] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NVTHUNGAN]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVTHUNGAN](
	[MaNV] [nchar](4) NOT NULL,
	[UserName] [nvarchar](20) NULL,
 CONSTRAINT [PK_NVTHUNGAN] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEUCHI]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEUCHI](
	[MaPhieuChi] [int] NOT NULL,
	[TienChi] [money] NULL,
	[NgayChi] [date] NULL,
	[MaNVTN] [nchar](4) NULL,
 CONSTRAINT [PK_PHIEUCHI] PRIMARY KEY CLUSTERED 
(
	[MaPhieuChi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[UserName] [nvarchar](20) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_USER] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BAN]  WITH CHECK ADD  CONSTRAINT [FK_BAN_KHUVUC] FOREIGN KEY([MaKhuVuc])
REFERENCES [dbo].[KHUVUC] ([MaKhuVuc])
GO
ALTER TABLE [dbo].[BAN] CHECK CONSTRAINT [FK_BAN_KHUVUC]
GO
ALTER TABLE [dbo].[CTHOADON]  WITH CHECK ADD  CONSTRAINT [FK_CTHOADON_HOADON] FOREIGN KEY([MaHD])
REFERENCES [dbo].[HOADON] ([MaHD])
GO
ALTER TABLE [dbo].[CTHOADON] CHECK CONSTRAINT [FK_CTHOADON_HOADON]
GO
ALTER TABLE [dbo].[CTHOADON]  WITH CHECK ADD  CONSTRAINT [FK_CTHOADON_MON] FOREIGN KEY([MaMon])
REFERENCES [dbo].[MON] ([MaMon])
GO
ALTER TABLE [dbo].[CTHOADON] CHECK CONSTRAINT [FK_CTHOADON_MON]
GO
ALTER TABLE [dbo].[CTPHIEUCHI]  WITH CHECK ADD  CONSTRAINT [FK_CTPHIEUCHI_NHOMCHI] FOREIGN KEY([MaNC])
REFERENCES [dbo].[NHOMCHI] ([MaNhomChi])
GO
ALTER TABLE [dbo].[CTPHIEUCHI] CHECK CONSTRAINT [FK_CTPHIEUCHI_NHOMCHI]
GO
ALTER TABLE [dbo].[CTPHIEUCHI]  WITH CHECK ADD  CONSTRAINT [FK_CTPHIEUCHI_PHIEUCHI] FOREIGN KEY([MaPC])
REFERENCES [dbo].[PHIEUCHI] ([MaPhieuChi])
GO
ALTER TABLE [dbo].[CTPHIEUCHI] CHECK CONSTRAINT [FK_CTPHIEUCHI_PHIEUCHI]
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_BAN] FOREIGN KEY([MaBan])
REFERENCES [dbo].[BAN] ([MaBan])
GO
ALTER TABLE [dbo].[HOADON] CHECK CONSTRAINT [FK_HOADON_BAN]
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_NVTHUNGAN] FOREIGN KEY([MaNVTN])
REFERENCES [dbo].[NVTHUNGAN] ([MaNV])
GO
ALTER TABLE [dbo].[HOADON] CHECK CONSTRAINT [FK_HOADON_NVTHUNGAN]
GO
ALTER TABLE [dbo].[MON]  WITH CHECK ADD  CONSTRAINT [FK_MON_LOAIMON] FOREIGN KEY([MaLoaiMon])
REFERENCES [dbo].[LOAIMON] ([MaLoaiMon])
GO
ALTER TABLE [dbo].[MON] CHECK CONSTRAINT [FK_MON_LOAIMON]
GO
ALTER TABLE [dbo].[NVPHUCVU]  WITH CHECK ADD  CONSTRAINT [FK_NVPHUCVU_NHANVIEN] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[NVPHUCVU] CHECK CONSTRAINT [FK_NVPHUCVU_NHANVIEN]
GO
ALTER TABLE [dbo].[NVTHUNGAN]  WITH CHECK ADD  CONSTRAINT [FK_NVTHUNGAN_NHANVIEN] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[NVTHUNGAN] CHECK CONSTRAINT [FK_NVTHUNGAN_NHANVIEN]
GO
ALTER TABLE [dbo].[NVTHUNGAN]  WITH CHECK ADD  CONSTRAINT [FK_NVTHUNGAN_USER] FOREIGN KEY([UserName])
REFERENCES [dbo].[USERS] ([UserName])
GO
ALTER TABLE [dbo].[NVTHUNGAN] CHECK CONSTRAINT [FK_NVTHUNGAN_USER]
GO
ALTER TABLE [dbo].[PHIEUCHI]  WITH CHECK ADD  CONSTRAINT [FK_PHIEUCHI_NVTHUNGAN] FOREIGN KEY([MaNVTN])
REFERENCES [dbo].[NVTHUNGAN] ([MaNV])
GO
ALTER TABLE [dbo].[PHIEUCHI] CHECK CONSTRAINT [FK_PHIEUCHI_NVTHUNGAN]
GO
/****** Object:  StoredProcedure [dbo].[USP_CheckLoaiNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CheckLoaiNV]
@maNV nchar(4)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT dbo.UF_CheckLoaiNV(@maNV)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCTPC]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DeleteCTPC]
@mapc int,
@manc nchar(4)
AS
BEGIN
	DELETE CTPHIEUCHI
	WHERE MaNC = @manc AND MaPC = @mapc 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteMon]
@mamon nchar(4)
AS
BEGIN
	DELETE MON
	WHERE MON.MaMon = @mamon
END

GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteNhomChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DeleteNhomChi]
@manc nchar(4)
AS
BEGIN
	DELETE NHOMCHI
	WHERE MaNhomChi = @manc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteNV]
@maNV nchar(4)
AS
BEGIN

	SET NOCOUNT ON;
	IF (@maNV IN (SELECT MaNV FROM NVPHUCVU))
	BEGIN
		DELETE FROM NVPHUCVU
		WHERE MaNV = @maNV
		DELETE FROM NHANVIEN
		WHERE MaNV = @maNV
	END
	IF (@maNV IN (SELECT MaNV FROM NVTHUNGAN))
	BEGIN
		DELETE FROM NVTHUNGAN
		WHERE MaNV = @maNV
	    DELETE FROM USERS
		WHERE UserName = @maNV
		DECLARE @SQLStringDropLogin nvarchar(2000)
		SET @SQLStringDropLogin = 'DROP LOGIN ['+@maNV+'];'
		exec(@SQLStringDropLogin)
		DECLARE @SQLStringDropUser nvarchar(2000)
		SET @SQLStringDropUser = 'DROP USER ['+@maNV+'];'
		exec(@SQLStringDropUser)
		DELETE FROM NHANVIEN
		WHERE MaNV = @maNV
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeletePhieuChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DeletePhieuChi]
@mapc int
AS
BEGIN
	DELETE PHIEUCHI
	WHERE MaPhieuChi = @mapc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GoiMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_GoiMon] @maHD int, @tenMon NVARCHAR(50), @soLuong INT
AS
BEGIN
	IF @soLuong > 0
	BEGIN
		DECLARE @maMon NCHAR(4)
		SELECT @maMon = MaMon FROM dbo.MON WHERE TenMon = @tenMon
	
		DECLARE @thanhTien FLOAT
		SELECT @thanhTien = GiaTien * @soLuong FROM dbo.MON WHERE MaMon = @maMon
	
		IF EXISTS (SELECT MaMon FROM dbo.CTHOADON WHERE MaHD = @maHD AND MaMon = @maMon)
			BEGIN
				UPDATE dbo.CTHOADON
				SET	SoLuong = SoLuong + @soLuong
				WHERE MaHD = @maHD AND MaMon = @maMon
				UPDATE dbo.CTHOADON
				SET ThanhTien = ThanhTien + @thanhTien
				WHERE MaHD = @maHD AND MaMon = @maMon
			END
	
		ELSE
			BEGIN
		
				INSERT INTO dbo.CTHOADON
						( MaHD, MaMon, SoLuong, ThanhTien )
				VALUES  ( @maHD, -- MaHD - int
						  @maMon, -- MaMon - nchar(4)
						  @soLuong, -- SoLuong - int
						  @thanhTien  -- ThanhTien - money
						  )
			END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayChiTietHD]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_LayChiTietHD] @maHD int
AS
BEGIN
	SELECT TenMon, SoLuong, GiaTien, ThanhTien = CAST(ThanhTien AS FLOAT)
	FROM dbo.CTHOADON JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
	WHERE MaHD = @maHD
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayDSGoiMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_LayDSGoiMon] @maBan NCHAR(4)
AS
BEGIN
	SELECT TenMon, SoLuong
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
		JOIN dbo.BAN ON BAN.MaBan = HOADON.MaBan
		JOIN dbo.MON ON MON.MaMon = CTHOADON.MaMon
	WHERE BAN.MaBan = @maBan AND HOADON.TrangThai = 0;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayMaHDChuaTT]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_LayMaHDChuaTT] @maBan NCHAR(4)
AS
BEGIN
	SELECT MaHD
	FROM dbo.HOADON 
	WHERE MaBan = @maBan AND TrangThai = 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayMonTheoLM]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_LayMonTheoLM] @tenLM NVARCHAR(50)
AS
BEGIN
	SELECT *
	FROM dbo.MON JOIN dbo.LOAIMON ON LOAIMON.MaLoaiMon = MON.MaLoaiMon
	WHERE TenLoaiMon = @tenLM
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayTienPhuThu]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_LayTienPhuThu] @maHD INT 
AS
BEGIN
	SELECT PhuThu
	FROM dbo.HOADON JOIN dbo.BAN ON BAN.MaBan = HOADON.MaBan
		JOIN dbo.KHUVUC ON KHUVUC.MaKhuVuc = BAN.MaKhuVuc
	WHERE MaHD = @maHD
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LayTongTien]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_LayTongTien] @maHD INT
AS
BEGIN
	SELECT SUM(ThanhTien) FROM dbo.CTHOADON WHERE MaHD = @maHD
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LoadCTPC]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_LoadCTPC]
AS
BEGIN
	SELECT * FROM CTPHIEUCHI
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LoadCTPCTheoNhomChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LoadCTPCTheoNhomChi]
@manc nchar(4)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT *
	FROM CTPHIEUCHI
	WHERE MaNC = @manc
END

GO
/****** Object:  StoredProcedure [dbo].[USP_LoadNhanVien]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[USP_LoadNhanVien] 
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM NHANVIEN
END

GO
/****** Object:  StoredProcedure [dbo].[USP_LoadNhomChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_LoadNhomChi]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM NHOMCHI
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LoadPhieuChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_LoadPhieuChi]
AS
BEGIN
	SELECT * FROM PHIEUCHI
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThanhToan]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ThanhToan] @maHD int
AS
BEGIN
	DECLARE @tongTien float
	SELECT @tongTien = SUM(ThanhTien) FROM dbo.CTHOADON WHERE MaHD = @maHD
	UPDATE dbo.HOADON
	SET	TongTien = @tongTien, TrangThai = 1
	WHERE MaHD = @maHD
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemCTPC]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ThemCTPC]
@mapc int,
@manc nchar(4),
@tongtien money
AS
BEGIN
	INSERT INTO CTPHIEUCHI
	VALUES(@mapc, @manc, @tongtien)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemHoaDon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ThemHoaDon] @maNVTN NCHAR(4), @maBan NCHAR(4)
AS
BEGIN
	INSERT INTO dbo.HOADON
	        ( TongTien ,
	          NgayLap ,
	          MaNVTN ,
	          MaBan ,
	          TrangThai
	        )
	VALUES  ( 0 , -- TongTien - int
	          GETDATE() , -- NgayLap - date
	          @maNVTN , -- MaNVTN - nchar(4)
	          @maBan , -- MaBan - nchar(4)
	          0  -- TrangThai - bit
	        )
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemMon]
@mamon nchar(4),
@tenmon nvarchar(50),
@maloaimon nchar(4),
@giatien float
AS
BEGIN
	INSERT INTO MON
	VALUES(@mamon,@tenmon, @maloaimon, @giatien)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_ThemNhomChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ThemNhomChi]
@manc nchar(4),
@tennc nvarchar(50)
AS
BEGIN
	INSERT INTO NHOMCHI
	VALUES (@manc, @tennc)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemNV]
@maNV nchar(4),
@tenNV nvarchar(50),
@cmnd nchar(10),
@soDT nchar(10),
@diachi nvarchar(50),
@ngaysinh date,
@ngayvaolam date
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO NHANVIEN
	VALUES(@maNV,@tenNV,@cmnd,@soDT,@diachi,@ngaysinh,@ngayvaolam)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemNVPhucVu]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemNVPhucVu]
@maNV nchar(4)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO NVPHUCVU
	VALUES(@maNV)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemNVThuNgan]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemNVThuNgan]
@maNV nchar(4)
AS
BEGIN
	SET NOCOUNT ON;
	exec USP_ThemTKNV @maNV
	INSERT INTO NVTHUNGAN
	VALUES(@maNV, @maNV)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemPhieuChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ThemPhieuChi]
@mapc int,
@tienchi money,
@ngaychi date,
@manvtn nchar(4)
AS
BEGIN
	INSERT INTO PHIEUCHI
	VALUES (@mapc, @tienchi, @ngaychi, @manvtn)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemTKLogin]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemTKLogin]
@TenTK nvarchar(20),
@MatKhau nvarchar(20)
AS
	BEGIN
	BEGIN TRANSACTION
	DECLARE @SQLStringCreateLogin nvarchar(2000)
	SET @SQLStringCreateLogin = 'CREATE LOGIN ['+@TenTK+'] WITH PASSWORD = '''+@MatKhau+''''+', DEFAULT_DATABASE=[MovieTheater], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON;'
	exec(@SQLStringCreateLogin)
	DECLARE @SQLStringCreateUser nvarchar(2000)
	SET @SQLStringCreateUser = 'CREATE USER [' + @TenTK + '] FOR LOGIN [' + @TenTK+']'
	EXEC(@SQLStringCreateUser)
	IF (@@ERROR <>0)
	BEGIN
		RAISERROR(N'Có lỗi xảy ra khi tạo tài khoản',16,1)
		rollback transaction
		return
	END
	commit transaction
end
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemTKNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThemTKNV]
@username nvarchar(20)
AS
BEGIN

	SET NOCOUNT ON;
	INSERT INTO USERS
	VALUES(@username,@username)
	exec USP_ThemTKLogin @username, @username
END

GO
/****** Object:  StoredProcedure [dbo].[USP_TimKiemMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_TimKiemMon] @ten NVARCHAR(50)
AS
BEGIN
	SELECT *
	FROM dbo.MON
	WHERE TenMon LIKE '%' + @ten + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TimKiemNVTheoMa]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TimKiemNVTheoMa]
@maNV nvarchar(4) 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM NHANVIEN
	WHERE MaNV LIKE ('%'+@maNV+'%')
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TimKiemNVTheoTen]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TimKiemNVTheoTen]
@tenNV nvarchar(50) 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM NHANVIEN
	WHERE TenNV LIKE ('%'+ @tenNV + '%')

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKLuotKhachTungNgay]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKLuotKhachTungNgay]
AS
BEGIN
	DECLARE @DauThangToiGio TABLE(ngay INT)
	DECLARE @date INT
	SET @date= 1
	WHILE @date<=DAY(GETDATE())
	BEGIN
		INSERT INTO @DauThangToiGio VALUES(@date)
		SET @date = @date + 1
	END
	DECLARE @LuotKhachTungNgay TABLE (SoLuong INT, Ngay INT)
	INSERT INTO @LuotKhachTungNgay
	SELECT SUM(SoLuong) AS SoLuong, DAY(NgayLap) AS Ngay
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
	WHERE MONTH(NgayLap) = MONTH(GETDATE()) AND YEAR(NgayLap) = YEAR(GETDATE())
	GROUP BY DAY(NgayLap)

	SELECT SoLuong AS SoLuong, CAST([@DauThangToiGio].ngay AS NCHAR(2)) AS Ngay
	FROM @LuotKhachTungNgay RIGHT JOIN @DauThangToiGio ON [@DauThangToiGio].ngay = [@LuotKhachTungNgay].Ngay

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongKhachNam]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongKhachNam]
AS
BEGIN
	SELECT SUM(SoLuong) 
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
	WHERE YEAR(NgayLap) = YEAR(GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongKhachThang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongKhachThang]	
AS
BEGIN
	SELECT SUM(SoLuong) 
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
	WHERE MONTH(NgayLap) = MONTH(GETDATE()) AND YEAR(NgayLap) = YEAR(GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongKhachTungThang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongKhachTungThang]
AS
BEGIN
	DECLARE @TongKhachTungThang TABLE (SoLuong INT, Thang INT)
	INSERT INTO @TongKhachTungThang
	SELECT SUM(SoLuong), MONTH(NgayLap) AS Thang
	FROM dbo.CTHOADON JOIN dbo.HOADON ON HOADON.MaHD = CTHOADON.MaHD
	WHERE YEAR(NgayLap) = YEAR(GETDATE())
	GROUP BY MONTH(NgayLap)

	SELECT SoLuong, chu AS Thang
	FROM @TongKhachTungThang RIGHT JOIN dbo.Thang() ON [@TongKhachTungThang].Thang = so
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongTienNam]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongTienNam]
AS
BEGIN
	SELECT SUM(TongTien) FROM dbo.HOADON
	WHERE YEAR(NgayLap) = YEAR(GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongTienThang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_TKTongTienThang]
AS
BEGIN
	SELECT SUM(TongTien) 
	FROM dbo.HOADON 
	WHERE MONTH(NgayLap) = MONTH(GETDATE()) AND YEAR(NgayLap) = YEAR(GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongTienTungNgay]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongTienTungNgay]
AS
BEGIN
	DECLARE @DauThangToiGio TABLE(ngay INT)
	DECLARE @date INT
	SET @date= 1
	WHILE @date<=DAY(GETDATE())
	BEGIN
		INSERT INTO @DauThangToiGio VALUES(@date)
		SET @date = @date + 1
	END

	DECLARE @TongTienTungNgay TABLE (tongTien INT, Ngay INT)
	INSERT INTO @TongTienTungNgay
	SELECT SUM(TongTien), DAY(NgayLap) AS Ngay
	FROM dbo.HOADON 
	WHERE MONTH(NgayLap) = MONTH(GETDATE()) AND YEAR(NgayLap) = YEAR(GETDATE())
	GROUP BY DAY(NgayLap)

	SELECT tongTien AS TongTien, CAST([@DauThangToiGio].ngay AS NCHAR(2)) AS Ngay
	FROM @TongTienTungNgay RIGHT JOIN @DauThangToiGio ON [@DauThangToiGio].ngay = [@TongTienTungNgay].Ngay

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTongTienTungThang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTongTienTungThang]
AS
BEGIN
	DECLARE @TongTienTungThang TABLE (TongTien INT, Thang INT)
	INSERT INTO @TongTienTungThang
	SELECT SUM(TongTien) AS TongTien, MONTH(NgayLap) AS Thang
	FROM dbo.HOADON
	WHERE YEAR(NgayLap) = YEAR(GETDATE())
	GROUP BY MONTH(NgayLap)

	SELECT TongTien, chu AS Thang
	FROM @TongTienTungThang RIGHT JOIN dbo.Thang() ON [@TongTienTungThang].Thang = so
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTop5MonNam]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_TKTop5MonNam]
AS
BEGIN
	SELECT * FROM dbo.UF_Top5Year()
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKTop5MonThang]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TKTop5MonThang]
AS
BEGIN
	SELECT * FROM dbo.UF_Top5Mon()
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCTPC]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdateCTPC]
@mapc int,
@manc nchar(4),
@tongtien money
AS
BEGIN
	UPDATE CTPHIEUCHI
	SET MaNC = @manc, TongTien = @tongtien
	WHERE MaPC = @mapc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateMon]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateMon]
@mamon nchar(4),
@tenmon nvarchar(50),
@giatien float
AS
BEGIN
	UPDATE MON
	SET TenMon = @tenmon, GiaTien = @giatien
	WHERE MaMon = @mamon
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateNhomChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdateNhomChi]
@manc nchar(4),
@tennc nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE NHOMCHI
	SET TenNhomChi = @tennc
	WHERE MaNhomChi = @manc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateNV]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateNV]
@maNV nchar(4),
@tenNV nvarchar(50),
@cmnd nchar(10),
@soDT nchar(10),
@diachi nvarchar(50),
@ngaysinh date,
@ngayvaolam date
AS
BEGIN

	SET NOCOUNT ON;
	UPDATE NHANVIEN
	SET TenNV = @tenNV, CMND = @cmnd, SoDT = @soDT, DiaChi = @diachi, NgaySinh = @ngaysinh , NgayVaoLam = @ngayvaolam
	WHERE MaNV = @maNV
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UpdatePhieuChi]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdatePhieuChi]
@mapc int,
@tienchi money,
@ngaychi date,
@manvtn nchar(4)
AS
BEGIN
	UPDATE PHIEUCHI
	SET TienChi = @tienchi, NgayChi = @ngaychi, MaNVTN = @manvtn
	WHERE MaPhieuChi = @mapc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateUser]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateUser] (@username NVARCHAR(50),@password NvarCHAR(50))
AS
BEGIN
BEGIN TRANSACTION
	UPDATE dbo.USERS SET Password=@password
	WHERE Username=@username

	DECLARE @SQLString NVARCHAR(500)
	SET @SQLString = 'ALTER LOGIN ['+@username+'] WITH PASSWORD ='''+@password+''''
	EXEC(@SQLString)
	
	
	IF(@@ERROR<>0)
	BEGIN 
		RAISERROR ('Oops! Something went wrong',16,1)
		ROLLBACK TRANSACTION
		RETURN
        end
	COMMIT TRANSACTION
	
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_XoaCTHD]    Script Date: 2/20/2025 3:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_XoaCTHD] @maHD INT
AS
BEGIN
	DELETE FROM dbo.CTHOADON WHERE MaHD = @maHD
END
GO
