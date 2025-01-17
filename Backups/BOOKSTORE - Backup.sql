USE [master]
GO
/****** Object:  Database [BOOKSTORE]    Script Date: 15.12.2017 20:11:32 ******/
CREATE DATABASE [BOOKSTORE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BOOKSTORE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\BOOKSTORE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BOOKSTORE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\BOOKSTORE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [BOOKSTORE] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOKSTORE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOKSTORE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOKSTORE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOKSTORE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOKSTORE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOKSTORE] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOKSTORE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BOOKSTORE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOKSTORE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOKSTORE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOKSTORE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOKSTORE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOKSTORE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOKSTORE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOKSTORE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOKSTORE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BOOKSTORE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOKSTORE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOKSTORE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOKSTORE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOKSTORE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOKSTORE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOKSTORE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOKSTORE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BOOKSTORE] SET  MULTI_USER 
GO
ALTER DATABASE [BOOKSTORE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOKSTORE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOKSTORE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOKSTORE] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BOOKSTORE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BOOKSTORE] SET QUERY_STORE = OFF
GO
USE [BOOKSTORE]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [BOOKSTORE]
GO
/****** Object:  Table [dbo].[ORDER]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDER](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[order_date] [date] NULL,
	[user_id] [int] NULL,
	[payment_id] [int] NULL,
	[feedback] [int] NOT NULL,
	[book_id] [int] NOT NULL,
 CONSTRAINT [PK_ORDER] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USER]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[phone_number] [varchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[zipcode] [int] NULL,
	[email] [nvarchar](50) NULL,
	[birth_date] [datetime] NULL,
	[age]  AS (CONVERT([smallint],datediff(year,[birth_date],getdate()))),
 CONSTRAINT [PK_USER] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BOOK]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOOK](
	[book_id] [int] IDENTITY(1,1) NOT NULL,
	[rate] [int] NOT NULL,
	[isbn] [nvarchar](50) NULL,
	[title] [nvarchar](50) NULL,
	[price] [decimal](19, 4) NULL,
	[publish_date] [date] NULL,
	[sold_quantity] [int] NULL,
	[author_id] [int] NULL,
 CONSTRAINT [PK_BOOK] PRIMARY KEY CLUSTERED 
(
	[book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Top10Customers]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Top10Customers] AS
SELECT DISTINCT TOP 10 u.user_id , u.first_name + ' ' + u.last_name AS full_name, SpendAmountTable.Amount
FROM [USER] u , [ORDER] o,
(SELECT SUM(Price) as Amount, u.user_id
FROM [USER] u , [BOOK] b,  [ORDER] o
WHERE u.user_id = o.user_id AND o.book_id = b.book_id 
GROUP BY u.user_id) as SpendAmountTable

WHERE SpendAmountTable.user_id = u.user_id
ORDER BY SpendAmountTable.Amount DESC
GO
/****** Object:  View [dbo].[Top10YoungestUsersTotalSpend]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Top10YoungestUsersTotalSpend] AS
SELECT TOP 10  u.user_id , u.age , u.first_name + ' ' + u.last_name AS full_name,  SUM(b.price) as TotalSpend
FROM [USER] u, [BOOK] b, [ORDER] o,
(SELECT u.user_id 
FROM [USER] u , (SELECT AVG(u.age) as AverageAge 
                        FROM [USER] u ) as YoungUsersTable
WHERE u.age < YoungUsersTable.AverageAge  ) AS TopYoungestTable

WHERE u.user_id = o.user_id AND b.book_id = o.book_id AND TopYoungestTable.user_id = u.user_id 

GROUP by u.user_id , u.age , u.first_name + ' ' + u.last_name 
ORDER by u.age ASC
GO
/****** Object:  Table [dbo].[BOOK-PUBLISHER]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOOK-PUBLISHER](
	[book_id] [int] NOT NULL,
	[publisher_id] [int] NOT NULL,
 CONSTRAINT [PK_BOOK-PUBLISHER] PRIMARY KEY CLUSTERED 
(
	[book_id] ASC,
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUBLISHER]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUBLISHER](
	[publisher_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[phone_number] [varchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[zipcode] [int] NULL,
 CONSTRAINT [PK_PUBLISHER] PRIMARY KEY CLUSTERED 
(
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PublisherIncome]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PublisherIncome] AS 
SELECT DISTINCT p.publisher_id,PublisherPrice.bookValue, p.name
FROM PUBLISHER AS p , BOOK as b,
(SELECT p.publisher_id,p.name
FROM PUBLISHER AS p
WHERE p.name like '%a%' ) AS includeA,

(SELECT p.publisher_id, SUM(b.price) AS bookValue
FROM [BOOK-PUBLISHER] AS bp, BOOK AS b, PUBLISHER AS p
WHERE p.publisher_id=bp.publisher_id 
AND bp.book_id=b.book_id
GROUP BY p.publisher_id) AS PublisherPrice
WHERE PublisherPrice.publisher_id= includeA.publisher_id AND
 p.publisher_id=PublisherPrice.publisher_id AND 
 p.publisher_id=includeA.publisher_id

GO
/****** Object:  Table [dbo].[BOOK-GENRE]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOOK-GENRE](
	[book_id] [int] NOT NULL,
	[genre_id] [int] NOT NULL,
 CONSTRAINT [PK_BOOK-GENRE] PRIMARY KEY CLUSTERED 
(
	[book_id] ASC,
	[genre_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GENRE]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GENRE](
	[genre_id] [int] IDENTITY(1,1) NOT NULL,
	[genre_info] [nvarchar](50) NULL,
 CONSTRAINT [PK_GENRE] PRIMARY KEY CLUSTERED 
(
	[genre_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAYMENT_TYPE]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAYMENT_TYPE](
	[payment_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_info] [nvarchar](50) NULL,
 CONSTRAINT [PK_PAYMENT_TYPE] PRIMARY KEY CLUSTERED 
(
	[payment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ListOrderPaymentTypes]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ListOrderPaymentTypes] AS
SELECT DISTINCT b.title , PaymentType.payment_info,GenreType.genre_info 
FROM BOOK AS b, [BOOK-GENRE] AS bg ,GENRE as g, 

(SELECT DISTINCT pt.payment_info, b.book_id
FROM  PAYMENT_TYPE AS pt , [ORDER] AS o,BOOK AS b
WHERE pt.payment_id=o.payment_id
AND o.book_id=b.book_id ) AS PaymentType,

(SELECT DISTINCT g.genre_info
FROM GENRE AS g ,[BOOK-GENRE] AS bg , BOOK AS b
where g.genre_id=bg.genre_id AND bg.book_id=b.book_id 
GROUP BY g.genre_id , g.genre_info) AS GenreType

WHERE b.book_id = PaymentType.book_id 
AND bg.book_id = b.book_id 
AND bg.genre_id = g.genre_id 
AND g.genre_info = GenreType.genre_info
GO
/****** Object:  Table [dbo].[AUTHOR]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUTHOR](
	[author_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[birth_date] [datetime] NULL,
 CONSTRAINT [PK_AUTHOR] PRIMARY KEY CLUSTERED 
(
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AUTHOR] ON 

INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (1, N'Mustafa Kemal', N'Atatürk', CAST(N'1881-05-19T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (2, N'George ', N'Orwell', CAST(N'1950-01-21T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (3, N'Dan', N'Brown', CAST(N'1964-06-22T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (4, N'Sabahattin ', N'Ali', CAST(N'1907-02-25T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (5, N'Zülfü', N'Livaneli', CAST(N'1946-06-20T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (6, N'Douglas', N'Adams', CAST(N'1952-03-11T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (7, N'Ahmet', N'Ümit', CAST(N'1960-07-12T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (8, N'Agatha ', N'Christie', CAST(N'1890-09-15T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (9, N'Edmondo', N'de Amicis', CAST(N'1846-10-21T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (10, N'Jules', N'Verne', CAST(N'1828-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (11, N'Antonine', N'de Saint-Exupery', CAST(N'1900-07-29T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (12, N'Alexandre', N'Dumas', CAST(N'1802-07-24T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (13, N'Charles ', N'Dickens', CAST(N'1812-02-07T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (14, N'Victor ', N'Hugo', CAST(N'1802-02-26T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (15, N'Charles', N'Darwin', CAST(N'1809-02-12T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (16, N'Adolf', N'Hitler', CAST(N'1889-04-20T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (17, N'Platon', NULL, NULL)
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (18, N'Franz ', N'Kafka', CAST(N'1883-07-03T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (19, N'Paulo', N'Coelho', CAST(N'1947-08-24T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (20, N'Ömer', N'Seyfettin', CAST(N'1884-03-11T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (21, N'J.R.R.', N'Tolkien', CAST(N'1892-01-03T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (22, N'Stephen', N'King', CAST(N'1942-01-03T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (23, N'Feride ', N'Çiçekoğlu', CAST(N'1951-01-01T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (24, N'İskender', N'Pala', CAST(N'1958-06-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (25, N'Cemal', N'Süreyya', CAST(N'1931-01-01T00:00:00.000' AS DateTime))
INSERT [dbo].[AUTHOR] ([author_id], [first_name], [last_name], [birth_date]) VALUES (26, N'Reşat Nuri', N'Güntekin', CAST(N'1889-10-25T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[AUTHOR] OFF
SET IDENTITY_INSERT [dbo].[BOOK] ON 

INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (1, 2, N'9789756424544', N'Nutuk', CAST(9.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 4, 1)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (2, 0, N'9789750719387', N'Hayvan Çiftliği', CAST(10.5000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 0, 2)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (4, 4, N'9789752123281', N'Başlangıç', CAST(35.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 3)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (7, 3, N'9789750800016', N'Kuyucaklı Yusuf', CAST(9.8000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 2, 4)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (8, 1, N'9786050940350', N'Huzursuzluk', CAST(15.4000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 5)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (10, 0, N'9786051715124', N'Otostopçunun Galaksi Rehberi', CAST(19.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 0, 6)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (11, 2, N'9789752897472', N'Agatha''nın Anahtarı', CAST(14.0000 AS Decimal(19, 4)), CAST(N'2010-01-01' AS Date), 0, 7)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (12, 1, N'9789754050226', N'On Küçük Zenci', CAST(15.0000 AS Decimal(19, 4)), CAST(N'2014-01-01' AS Date), 1, 8)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (13, 0, N'9789752897373', N'Sis ve Gece', CAST(19.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 7)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (15, 0, N'9789754880090', N'Çocuk Kalbi', CAST(12.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 9)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (16, 3, N'9786059484084', N'Küçük Prens', CAST(8.5000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 11)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (17, 0, N'9786051713083', N'Balonla Beş Hafta', CAST(19.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 10)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (18, 2, N'9786051715902', N'Üç Silahşörler', CAST(27.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 0, 12)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (19, 5, N'9789752565470', N'Oliver Twist', CAST(12.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 13)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (20, 0, N'9789756195109', N'Sefiller', CAST(13.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 14)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (21, 5, N'9789752474819', N'Türlerin Kökeni', CAST(15.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 1, 15)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (22, 3, N'9786054977635', N'Kavgam', CAST(24.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 16)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (23, 4, N'9786054962112', N'Sokrates''in Savunması', CAST(7.0000 AS Decimal(19, 4)), CAST(N'2014-01-01' AS Date), 1, 17)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (24, 0, N'9786054962969', N'Aforizmalar', CAST(5.0000 AS Decimal(19, 4)), CAST(N'2015-01-01' AS Date), 0, 18)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (25, 0, N'9789750726439', N'Simyacı', CAST(15.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 19)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (27, 4, N'9786059059510', N'Yalnız Efe', CAST(12.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 1, 20)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (28, 0, N'9789944118712', N'Kaşağı', CAST(8.0000 AS Decimal(19, 4)), CAST(N'2010-01-01' AS Date), 0, 20)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (29, 0, N'9789752733732', N'Hobbit', CAST(13.0000 AS Decimal(19, 4)), CAST(N'2017-01-01' AS Date), 0, 21)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (30, 2, N'9789754054217', N'Göz', CAST(13.0000 AS Decimal(19, 4)), CAST(N'2003-01-01' AS Date), 1, 22)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (31, 0, N'9789755101415', N'Uçurtmayı Vurmasınlar', CAST(8.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 23)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (32, 0, N'9789758950379', N'İki Dirhem Bir Çekirdek', CAST(15.0000 AS Decimal(19, 4)), CAST(N'2016-01-01' AS Date), 0, 24)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (34, 2, N'9789753634564', N'Sevda Sözleri', CAST(19.0000 AS Decimal(19, 4)), CAST(N'2015-01-01' AS Date), 1, 25)
INSERT [dbo].[BOOK] ([book_id], [rate], [isbn], [title], [price], [publish_date], [sold_quantity], [author_id]) VALUES (35, 0, N'9789751015440', N'Çalıkuşu', CAST(15.0000 AS Decimal(19, 4)), CAST(N'2014-01-01' AS Date), 0, 26)
SET IDENTITY_INSERT [dbo].[BOOK] OFF
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (1, 9)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (2, 13)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (4, 2)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (7, 11)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (8, 14)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (10, 3)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (11, 1)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (12, 1)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (13, 1)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (15, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (16, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (17, 2)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (17, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (18, 2)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (18, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (19, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (20, 10)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (21, 5)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (22, 9)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (23, 5)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (24, 5)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (25, 2)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (25, 3)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (27, 4)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (28, 4)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (29, 2)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (29, 15)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (30, 16)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (31, 17)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (32, 6)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (34, 8)
INSERT [dbo].[BOOK-GENRE] ([book_id], [genre_id]) VALUES (35, 11)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (2, 1)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (4, 11)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (7, 18)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (8, 13)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (10, 14)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (11, 15)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (12, 11)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (13, 15)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (15, 17)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (16, 16)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (17, 16)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (18, 22)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (19, 22)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (20, 22)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (21, 23)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (22, 30)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (23, 24)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (24, 23)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (25, 1)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (27, 25)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (28, 25)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (29, 20)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (30, 11)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (31, 1)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (32, 28)
INSERT [dbo].[BOOK-PUBLISHER] ([book_id], [publisher_id]) VALUES (34, 18)
SET IDENTITY_INSERT [dbo].[GENRE] ON 

INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (3, N'Bilim Kurgu')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (7, N'Biyografi')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (10, N'Çocuk-Klasik')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (6, N'Deneme')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (17, N'Drama')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (15, N'Fantastik')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (5, N'Felsefe')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (13, N'Hiciv')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (4, N'Hikaye')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (12, N'Klasik')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (16, N'Korku')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (2, N'Macera')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (1, N'Polisiye')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (14, N'Roman')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (11, N'Romantik')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (8, N'Şiir')
INSERT [dbo].[GENRE] ([genre_id], [genre_info]) VALUES (9, N'Tarih')
SET IDENTITY_INSERT [dbo].[GENRE] OFF
SET IDENTITY_INSERT [dbo].[ORDER] ON 

INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (9, CAST(N'2010-01-01' AS Date), 1, 1, 3, 1)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (10, CAST(N'2015-10-15' AS Date), 1, 1, 2, 11)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (11, CAST(N'2011-05-30' AS Date), 1, 1, 4, 7)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (13, CAST(N'2012-08-04' AS Date), 2, 1, 3, 1)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (20, CAST(N'2017-06-09' AS Date), 2, 1, 3, 7)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (22, CAST(N'2016-02-27' AS Date), 3, 2, 4, 4)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (25, CAST(N'2015-08-09' AS Date), 16, 1, 3, 16)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (26, CAST(N'2014-07-15' AS Date), 20, 1, 2, 34)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (27, CAST(N'2014-02-12' AS Date), 12, 1, 4, 23)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (28, CAST(N'2016-12-10' AS Date), 26, 1, 1, 12)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (29, CAST(N'2013-01-20' AS Date), 23, 1, 2, 30)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (30, CAST(N'2014-01-25' AS Date), 17, 1, 1, 1)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (31, CAST(N'2016-10-24' AS Date), 15, 2, 3, 22)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (32, CAST(N'2017-04-21' AS Date), 9, 1, 5, 21)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (34, CAST(N'2014-12-01' AS Date), 14, 1, 4, 27)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (35, CAST(N'2015-03-01' AS Date), 21, 1, 1, 8)
INSERT [dbo].[ORDER] ([order_id], [order_date], [user_id], [payment_id], [feedback], [book_id]) VALUES (36, CAST(N'2011-10-11' AS Date), 21, 2, 5, 19)
SET IDENTITY_INSERT [dbo].[ORDER] OFF
SET IDENTITY_INSERT [dbo].[PAYMENT_TYPE] ON 

INSERT [dbo].[PAYMENT_TYPE] ([payment_id], [payment_info]) VALUES (2, N'Kredi Kartı')
INSERT [dbo].[PAYMENT_TYPE] ([payment_id], [payment_info]) VALUES (1, N'Nakit')
SET IDENTITY_INSERT [dbo].[PAYMENT_TYPE] OFF
SET IDENTITY_INSERT [dbo].[PUBLISHER] ON 

INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (1, N'Can Yayınları', N'02122525988', N'İstanbul', N'Beyoğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (11, N'Altın Kitaplar', N'02124463888', N'İstanbul', N'Bağcılar', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (13, N'Doğan Kitap', N'02123737700', N'İstanbul', N'Üsküdar', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (14, N'Alfa Yayınları', N'02125115303', N'İstanbul', N'Fatih', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (15, N'Everest Yayınları', N'02125133420', N'İstanbul', N'Cağaloğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (16, N'Arkadaş Yayınevi', N'03123960111', N'Ankara', N'Yenimahalle', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (17, N'İş Bankası Kültür Yayınları', N'02122523991', N'İstanbul', N'Beyoğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (18, N'Yapı Kredi Yayınları', N'02122524700', N'İstanbul', N'Beyoğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (20, N'İthaki Yayınları', N'02163483697', N'İstanbul', N'Kadıköy', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (22, N'Bilgi Yayınevi', N'03124318122', N'Ankara', N'Yenişehir', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (23, N'Tutku Yayınevi', N'05559967895', N'Ankara', N'Çankaya', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (24, N'Sis Yayıncılık', N'02163306221', N'İstanbul', N'Kadıköy', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (25, N'Timaş Yayınları', N'02125112424', N'İstanbul', N'Cağaloğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (28, N'Kapı Yayınları', N'02125133421', N'İstanbul', N'Cağaloğlu', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (29, N'İnkılap Yayınevi', N'02124961111', N'İstanbul', N'Yenibosna', NULL)
INSERT [dbo].[PUBLISHER] ([publisher_id], [name], [phone_number], [city], [state], [zipcode]) VALUES (30, N'İlgi Kültür Sanat Yayınları', N'02125263975', N'İstanbul', N'Fatih', NULL)
SET IDENTITY_INSERT [dbo].[PUBLISHER] OFF
SET IDENTITY_INSERT [dbo].[USER] ON 

INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (1, N'Gökhan', N'Çulfacı', N'05436669982', N'Istanbul', N'Üsküdar', 35900, N'ferhat@hotmail.com', CAST(N'2001-05-23T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (2, N'Ferhat', N'Özkan', N'05338767122', N'Izmir', N'Göztepe', 35220, N'gokhan@hotmail.com', CAST(N'2010-01-01T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (3, N'Ayşe', N'Hatun', N'05411111111', N'Trabzon', N'Of', 34111, N'ayse@hotmail.com', CAST(N'1997-03-03T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (4, N'Pablo', N'Picasso', N'04992222114', N'Italya', N'Roma', 11111, N'picassopablo@yahoo.com', CAST(N'1990-01-23T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (5, N'Mursel ', N'Budak', N'05555433952', N'İstanbul', N'Üsküdar', 35445, N'mbudak@gmail.com', CAST(N'1989-05-01T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (9, N'Tuğra ', N'Keskin', N'05688852145', N'Rize', N'Çaykara', 65456, N'keskin@hotmail.com', CAST(N'1980-12-25T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (10, N'Sinan', N'Aykut', N'05425468742', N'Kayseri', N'Melikgazi', 45645, N'sinan.a@gmail.com', CAST(N'1999-05-30T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (11, N'İnci', N'Ceren', N'05214645856', N'Hakkari', N'Şemdinli', 45644, N'incic@hotmail.com', CAST(N'1994-02-02T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (12, N'Kardelen ', N'Saltuk', N'05324085421', N'Trabzon', N'Of', 12323, N'karsaltuk@gmail.com', CAST(N'1995-05-23T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (13, N'Berke Can', N'Aktuna', N'05442546799', N'İstanbul', N'Çengelköy', 12318, N'berkeaktuna@gmail.com', CAST(N'1998-06-18T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (14, N'Göksel', N'Kozan', N'05456548654', N'İstanbul', N'Beykoz', 45687, N'göksel.kozan@hotmail.com', CAST(N'1999-10-14T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (15, N'Mahmut', N'Kıraç', N'05351478536', N'İstanbul', N'Beşiktaş', 35154, N'mahmutkir@gmail.com', CAST(N'1987-01-25T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (16, N'Su', N'Aziz', N'05458752154', N'İstanbul', N'Beylikdüzü', 48489, N'suaziz@gmail.com', CAST(N'1989-09-08T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (17, N'Niyazi', N'Önem', N'05368974521', N'İzmir', N'Karşıyaka', 84845, N'niyazionem@gmail.com', CAST(N'2000-01-01T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (18, N'Efe', N'Yalçın', N'05342562314', N'Bursa', N'Mudanya', 41566, N'efeyalcin@hotmail.com', CAST(N'2001-05-31T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (19, N'Işın ', N'Opak', N'05357668952', N'Bursa', N'Mudanya', 41566, N'isin@gmail.com', CAST(N'2002-12-04T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (20, N'Serhat', N'Üner', N'05462145632', N'İstanbul', N'Üsküdar', 35445, N'serhatuner@gmail.com', CAST(N'1997-06-19T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (21, N'Demircan', N'Dalkılıç', N'05066145265', N'Ordu', N'Ünye', 25489, N'demircan@gmail.com', CAST(N'1998-03-21T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (22, N'Bihter', N'Bilici', N'05066145658', N'İstanbul', N'Ataşehir', 26545, N'bihterbilici@gmail.com', CAST(N'1970-02-16T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (23, N'Toprak', N'Bora', N'05050214254', N'İstanbul', N'Kadıköy', 21565, N'toprakbora@hotmail.com', CAST(N'1991-02-15T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (24, N'Aykut ', N'Günay', N'05362145687', N'Ankara', N'Yenimahalle', 22666, N'aykutgunay@gmail.com', CAST(N'1977-09-22T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (25, N'Tankut ', N'Polat', N'05094558412', N'Ankara', N'Çankaya', 56484, N'tankutpolat@gmail.com', CAST(N'2005-08-14T00:00:00.000' AS DateTime))
INSERT [dbo].[USER] ([user_id], [first_name], [last_name], [phone_number], [city], [state], [zipcode], [email], [birth_date]) VALUES (26, N'Merve', N'Öz', N'05555468896', N'İstanbul', N'Kadıköy', 21565, N'merveoz@gmail.com', CAST(N'1999-08-15T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[USER] OFF
/****** Object:  Index [IX_book_id_BOOK]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_book_id_BOOK] ON [dbo].[BOOK]
(
	[book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_isbn_BOOK]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_isbn_BOOK] ON [dbo].[BOOK]
(
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_genre_info_GENRE]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_genre_info_GENRE] ON [dbo].[GENRE]
(
	[genre_info] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_id_ORDER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_order_id_ORDER] ON [dbo].[ORDER]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_paymet_info_PAYMENT_TYPE]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_paymet_info_PAYMENT_TYPE] ON [dbo].[PAYMENT_TYPE]
(
	[payment_info] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_publisher_id_PUBLISHER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_publisher_id_PUBLISHER] ON [dbo].[PUBLISHER]
(
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_name_PUBLISHER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_name_PUBLISHER] ON [dbo].[PUBLISHER]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_phone_number_PUBLISHER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_phone_number_PUBLISHER] ON [dbo].[PUBLISHER]
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_user_id_USER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_user_id_USER] ON [dbo].[USER]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_email_USER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_email_USER] ON [dbo].[USER]
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_phone_number_USER]    Script Date: 15.12.2017 20:11:33 ******/
CREATE NONCLUSTERED INDEX [UQ_phone_number_USER] ON [dbo].[USER]
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BOOK] ADD  CONSTRAINT [DF_BOOK_rate]  DEFAULT ((0)) FOR [rate]
GO
ALTER TABLE [dbo].[BOOK] ADD  CONSTRAINT [DF_BOOK_sold_quantity]  DEFAULT ((0)) FOR [sold_quantity]
GO
ALTER TABLE [dbo].[ORDER] ADD  CONSTRAINT [DF_ORDER_feedback]  DEFAULT ((0)) FOR [feedback]
GO
ALTER TABLE [dbo].[PAYMENT_TYPE] ADD  CONSTRAINT [DF_PAYMENT_TYPE_payment_info]  DEFAULT (N'Cash') FOR [payment_info]
GO
ALTER TABLE [dbo].[BOOK]  WITH CHECK ADD  CONSTRAINT [FK_BOOK_AUTHOR] FOREIGN KEY([author_id])
REFERENCES [dbo].[AUTHOR] ([author_id])
GO
ALTER TABLE [dbo].[BOOK] CHECK CONSTRAINT [FK_BOOK_AUTHOR]
GO
ALTER TABLE [dbo].[BOOK-GENRE]  WITH CHECK ADD  CONSTRAINT [FK_BOOK-GENRE_BOOK] FOREIGN KEY([book_id])
REFERENCES [dbo].[BOOK] ([book_id])
GO
ALTER TABLE [dbo].[BOOK-GENRE] CHECK CONSTRAINT [FK_BOOK-GENRE_BOOK]
GO
ALTER TABLE [dbo].[BOOK-GENRE]  WITH CHECK ADD  CONSTRAINT [FK_BOOK-GENRE_GENRE] FOREIGN KEY([genre_id])
REFERENCES [dbo].[GENRE] ([genre_id])
GO
ALTER TABLE [dbo].[BOOK-GENRE] CHECK CONSTRAINT [FK_BOOK-GENRE_GENRE]
GO
ALTER TABLE [dbo].[BOOK-PUBLISHER]  WITH CHECK ADD  CONSTRAINT [FK_BOOK-PUBLISHER_BOOK] FOREIGN KEY([book_id])
REFERENCES [dbo].[BOOK] ([book_id])
GO
ALTER TABLE [dbo].[BOOK-PUBLISHER] CHECK CONSTRAINT [FK_BOOK-PUBLISHER_BOOK]
GO
ALTER TABLE [dbo].[BOOK-PUBLISHER]  WITH CHECK ADD  CONSTRAINT [FK_BOOK-PUBLISHER_PUBLISHER] FOREIGN KEY([publisher_id])
REFERENCES [dbo].[PUBLISHER] ([publisher_id])
GO
ALTER TABLE [dbo].[BOOK-PUBLISHER] CHECK CONSTRAINT [FK_BOOK-PUBLISHER_PUBLISHER]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_BOOK] FOREIGN KEY([book_id])
REFERENCES [dbo].[BOOK] ([book_id])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_BOOK]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_PAYMENT_TYPE] FOREIGN KEY([payment_id])
REFERENCES [dbo].[PAYMENT_TYPE] ([payment_id])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_PAYMENT_TYPE]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_USER] FOREIGN KEY([user_id])
REFERENCES [dbo].[USER] ([user_id])
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [FK_ORDER_USER]
GO
ALTER TABLE [dbo].[BOOK]  WITH CHECK ADD  CONSTRAINT [CK_BOOK_isbn] CHECK  ((len([isbn])=(13)))
GO
ALTER TABLE [dbo].[BOOK] CHECK CONSTRAINT [CK_BOOK_isbn]
GO
ALTER TABLE [dbo].[ORDER]  WITH CHECK ADD  CONSTRAINT [CK_ORDER_feedback] CHECK  (([feedback]>(0) AND [feedback]<(6)))
GO
ALTER TABLE [dbo].[ORDER] CHECK CONSTRAINT [CK_ORDER_feedback]
GO
ALTER TABLE [dbo].[PUBLISHER]  WITH NOCHECK ADD  CONSTRAINT [CK_PUBLISHER_phone_number] CHECK  ((len([phone_number])=(11)))
GO
ALTER TABLE [dbo].[PUBLISHER] NOCHECK CONSTRAINT [CK_PUBLISHER_phone_number]
GO
ALTER TABLE [dbo].[USER]  WITH CHECK ADD  CONSTRAINT [CK_USER_phone_number] CHECK  ((len([phone_number])=(11)))
GO
ALTER TABLE [dbo].[USER] CHECK CONSTRAINT [CK_USER_phone_number]
GO
/****** Object:  StoredProcedure [dbo].[GetBookInfo]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetBookInfo]
	@bookid int,
	@bookname nvarchar(50) OUTPUT	,
	@genre nvarchar(50) OUTPUT	,
	@SoldAmount int OUTPUT,
	@TotalIncome decimal(19,4) OUTPUT	
		
	
AS
declare 

	@bookprice decimal(19,4)


set @bookname = (select b.title
					from [BOOK] b
					where b.book_id = @bookid);

set @SoldAmount = (select b.sold_quantity
					from [BOOK] b
					where b.book_id = @bookid);


set @bookprice = (select b.price
					from [BOOK] b
					where b.book_id = @bookid);


set @TotalIncome = @SoldAmount * @bookprice;


set @genre = (select g.genre_info
					from [BOOK] b , [GENRE] g, [BOOK-GENRE] bg
 					where b.book_id = @bookid AND g.genre_id =bg.genre_id AND bg.book_id = b.book_id);


IF @TotalIncome IS NULL SET @TotalIncome = 0
GO
/****** Object:  StoredProcedure [dbo].[GetGenreIncome]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetGenreIncome]
	@genreinfo nvarchar(50),
	@totalincome decimal(19,4) OUTPUT
	
AS

set @totalincome = ( SELECT IncomeTable.TotalIncome as TotalIncome
					FROM  [GENRE] g, (SELECT g.genre_info ,(NumSoldTable.SoldQuantity*PriceTable.price)  AS [TotalIncome]
					FROM [BOOK-GENRE] bk, [GENRE] g, [BOOK] b,  
					(SELECT g.genre_info, b.price 
					FROM [ORDER] o, [BOOK] b, [BOOK-GENRE] bg, [GENRE] g
					WHERE b.book_id = bg.book_id AND bg.genre_id = g.genre_id  AND o.book_id = b.book_id
					GROUP BY g.genre_info,b.price) as PriceTable,

					(SELECT g.genre_info, b.sold_quantity as SoldQuantity 
					FROM [ORDER] o, [BOOK] b, [BOOK-GENRE] bg, [GENRE] g
					WHERE b.book_id = bg.book_id AND bg.genre_id = g.genre_id  AND o.book_id = b.book_id
					GROUP BY g.genre_info, b.sold_quantity) as NumSoldTable

					WHERE b.book_id = bk.book_id AND bk.genre_id = g.genre_id AND NumSoldTable.genre_info = @genreinfo AND PriceTable.genre_info = g.genre_info
					GROUP BY g.genre_info , (NumSoldTable.SoldQuantity*PriceTable.price)) as IncomeTable 

					WHERE   g.genre_info = @genreinfo AND g.genre_info = IncomeTable.genre_info );


IF @totalincome IS NULL SET @totalincome = 0


GO
/****** Object:  StoredProcedure [dbo].[GetPopularBooks]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetPopularBooks]
	@date1 date,
	@date2 date,
	@popgenre nvarchar(50) OUTPUT,
	@income decimal(19,4) OUTPUT	
AS

	SET @popgenre =	(	SELECT g.genre_info 
						FROM [GENRE] g , (SELECT TOP 1  g.genre_info, COUNT(*) as SoldQuantity 
										  FROM [ORDER] o, [BOOK] b, [BOOK-GENRE] bg, [GENRE] g
										  WHERE b.book_id = bg.book_id AND bg.genre_id = g.genre_id  AND o.book_id = b.book_id AND  o.order_date >  @date1 AND o.order_date <  @date2
						                  GROUP BY g.genre_info 
						                  ORDER BY SoldQuantity DESC ) as PopularGenre
                        WHERE g.genre_info = PopularGenre.genre_info );


   SET @income =  ( SELECT IncomeTable.TotalIncome as TotalIncome
					FROM  [GENRE] g, (SELECT g.genre_info ,(PopularGenre.SoldQuantity*PriceTable.price)  AS [TotalIncome]
					FROM [BOOK-GENRE] bk, [GENRE] g, [BOOK] b,  
					(SELECT g.genre_info, b.price 
					FROM [ORDER] o, [BOOK] b, [BOOK-GENRE] bg, [GENRE] g
					WHERE b.book_id = bg.book_id AND bg.genre_id = g.genre_id  AND o.book_id = b.book_id AND g.genre_info = @popgenre
					GROUP BY g.genre_info,b.price) as PriceTable,

					(SELECT TOP 1  g.genre_info, COUNT(*) as SoldQuantity 
										  FROM [ORDER] o, [BOOK] b, [BOOK-GENRE] bg, [GENRE] g
										  WHERE b.book_id = bg.book_id AND bg.genre_id = g.genre_id  AND o.book_id = b.book_id  AND  o.order_date >  @date1 AND o.order_date <  @date2
						                  GROUP BY g.genre_info 
						                  ORDER BY SoldQuantity DESC ) as PopularGenre

					WHERE b.book_id = bk.book_id AND bk.genre_id = g.genre_id AND PopularGenre.genre_info = @popgenre AND PriceTable.genre_info = @popgenre
					GROUP BY  g.genre_info , (PopularGenre.SoldQuantity*PriceTable.price) ) as IncomeTable 

					WHERE   g.genre_info = @popgenre AND g.genre_info = IncomeTable.genre_info );


IF @income IS NULL SET @income = 0
IF @popgenre IS NULL SET @popgenre = 'Couldnt find any order!'
GO
/****** Object:  StoredProcedure [dbo].[GetSpendMoney]    Script Date: 15.12.2017 20:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetSpendMoney]
	@u_email nvarchar(50),
	@totalspend decimal(19,4) OUTPUT	
AS

	set @totalspend = (SELECT   SUM(NumBooksTable.numberOfBooks*PricesTable.prices) as spendtotal
						FROM  [USER] u, [ORDER] o, [BOOK] b,
						(SELECT u.user_id, b.book_id, o.order_id, COUNT(b.book_id) as numberOfBooks
						FROM [USER] u, [ORDER] o , [BOOK] b
						WHERE b.book_id = o.book_id AND o.user_id = u.user_id  
						GROUP BY b.book_id , u.user_id, o.order_id) as NumBooksTable,
						(SELECT u.user_id, o.order_id , u.email, b.book_id,  b.price as prices
						FROM  [USER] u, [ORDER] o , [BOOK] b
						WHERE b.book_id = o.book_id AND o.user_id = u.user_id
						GROUP BY  u.email,u.user_id, b.book_id , o.order_id, b.price) as PricesTable

						WHERE  b.book_id = o.book_id AND u.user_id = o.user_id AND  u.email = @u_email AND u.user_id = PricesTable.user_id AND u.user_id = NumBooksTable.user_id AND
						 PricesTable.user_id = NumBooksTable.user_id   AND o.order_id = PricesTable.order_id AND o.order_id = NumBooksTable.order_id
						AND b.book_id = NumBooksTable.book_id  AND b.book_id = PricesTable.book_id

						GROUP by u.user_id );

IF @totalspend IS NULL SET @totalspend = 0
GO
USE [master]
GO
ALTER DATABASE [BOOKSTORE] SET  READ_WRITE 
GO
