create database Prodaja_termina
use Prodaja_termina
--tabele
create table Korisnik
(id int primary key identity(1,1),
email nvarchar(40) not null,
pass nvarchar(20) not null
)

create table Lokacija
(id int primary key identity(1,1),
grad nvarchar(20) not null
)

create table Tip_karte
(id int primary key identity(1,1),
naziv nvarchar(30) not null,
cena money not null
)

create table Proizvodi
(id int primary key identity(1,1),
naziv nvarchar(30) not null,
cena int not null
)

create table Bazeni
(id int primary key identity(1,1),
naziv nvarchar(30) not null,
lokacija_id int not null
)

create table Termini
(id int primary key identity(1,1),
tip_karte_id int not null,
pocetak_termina time not null,
kraj_termina time not null
)

create table Iznajmljivanje
(id int primary key identity(1,1),
korisnik_id int not null,
termin_id int not null,
datum date not null,
bazen_id int not null
)
--relacioni integritet

alter table Bazeni
add constraint
FK_lokacija_id foreign key
(lokacija_id) references Lokacija(id)

alter table Termini 
add constraint
FK_tip_karte_id foreign key
(tip_karte_id) references Tip_karte(id)

alter table Iznajmljivanje 
add constraint
FK_korisnik_id foreign key
(korisnik_id) references Korisnik(id)

alter table Iznajmljivanje 
add constraint
FK_termin_id foreign key
(termin_id) references Termini(id)

alter table Iznajmljivanje 
add constraint
FK_bazen_id foreign key
(bazen_id) references Bazeni(id)

--store procedure

--Korisnik
create proc dbo.Korisnik_Email
@email nvarchar(40),
@loz nvarchar(20)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS(SELECT TOP 1 email FROM Korisnik
	WHERE email = @email and pass=@loz)
	Begin
	RETURN 0
	end
	RETURN 1
END TRY
BEGIN CATCH
	RETURN @@error;
END CATCH

create PROC Korisnik_Insert
@email nvarchar(50),
@loz nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 email  FROM Korisnik
	WHERE email = @email)
	Return 1
	else
	Insert Into Korisnik(email, pass)
	Values(@email, @loz)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create PROC dbo.Korisnik_Update
@email nvarchar(50),
@loz nvarchar(100)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 email FROM Korisnik
	WHERE email = @email  )
	BEGIN
	Update Korisnik set pass = @loz where email=@email 
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

create Proc Korisnik_Delete
@email nvarchar(100)
as
Begin TRY
Delete from Korisnik where email=@email
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create proc Broj_Korisnika
as
select count(email) from Korisnik

exec Korisnik_Update 'anstefan@gmail.com', '1235'
exec Korisnik_Insert 'tralala@gmail.com', '1277'
exec Korisnik_Delete 'tralala@gmail.com'
exec Korisnik_Email 'anstefan@gmail.com', '1234'
exec Broj_Korisnika
select * from Korisnik

--Lokacija

create PROC Lokacija_Insert
@grad nvarchar(20)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 grad  FROM Lokacija
	WHERE grad = @grad)
	Return 1
	else
	Insert Into Lokacija(grad)
	Values(@grad) 
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

alter PROC dbo.Lokacija_Update
@id int,
@grad nvarchar(20)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 id FROM Lokacija
	WHERE id = @id)
	BEGIN
	Update Lokacija set grad = @grad where id=@id 
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create Proc Lokacija_Delete
@grad nvarchar(20)
as
Begin TRY
Delete from Lokacija where grad=@grad
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

exec dbo.Lokacija_Update 4 , 'Pancevo'
exec Lokacija_Insert 'Vrsac'
exec Lokacija_Delete 'Vrsac'
select * from Lokacija

--tip_karte

create PROC Tip_Karte_Insert
@naziv nvarchar(30),
@cena money
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 naziv  FROM Tip_karte
	WHERE naziv = @naziv)
	Return 1
	else
	Insert Into Tip_karte(naziv, cena)
	Values(@naziv, @cena)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create PROC dbo.Tip_Karte_Update
@naziv nvarchar(30),
@cena money
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 naziv FROM Tip_karte
	WHERE naziv = @naziv)
	BEGIN
	Update Tip_karte set cena = @cena where naziv=@naziv 
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create Proc Tip_Karte_Delete
@naziv nvarchar(30)
as
Begin TRY
Delete from Tip_karte where naziv=@naziv
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

exec Tip_Karte_Update 'odrasli', '450'
exec Tip_Karte_Insert 'penzioneri', '300'
exec Tip_Karte_Delete 'penzioneri'
select * from Tip_karte

--proizvodi

alter PROC Proizvodi_Insert
@naziv nvarchar(30),
@cena int 
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 naziv  FROM Proizvodi
	WHERE naziv = @naziv)
	Return 1
	else
	Insert Into Proizvodi(naziv, cena)
	Values(@naziv, @cena)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

alter PROC dbo.Proizvodi_Update
@naziv nvarchar(30),
@cena int
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 naziv FROM Proizvodi
	WHERE naziv = @naziv)
	BEGIN
	Update Proizvodi set cena = @cena where naziv=@naziv 
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

create Proc Proizvodi_Delete
@naziv nvarchar(30)
as
Begin TRY
Delete from Proizvodi where naziv=@naziv
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

exec Proizvodi_Update 'lezaljka', '200'
exec Proizvodi_Insert 'lezaljka ispod pergole', '250'
exec Proizvodi_Delete 'lezaljka ispod pergole'
select * from Proizvodi

--bazeni

Create PROC Bazen_Insert
@naziv nvarchar(30),
@lokacija_id int 
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 naziv  FROM Bazeni
	WHERE naziv = @naziv and lokacija_id=@lokacija_id)
	Return 1
	else
	Insert Into Bazeni(naziv, lokacija_id)
	Values(@naziv,@lokacija_id)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create PROC Bazeni_Update
@id int,
@naziv nvarchar(30),
@lokacija_id int
AS
SET LOCK_TIMEOUT 3000;

BEGIN TRY
	IF EXISTS (SELECT TOP 1 naziv FROM Bazeni
	WHERE id = @id )
	BEGIN
	Update Bazeni Set naziv=@naziv, lokacija_id=@lokacija_id where id=@id
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create Proc Bazeni_Delete
@naziv nvarchar(30),
@lokacija_id int
as
Begin TRY
Delete from Bazeni where naziv=@naziv and lokacija_id=@lokacija_id
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

alter PROC Ukupno_Bazeni
as
select count(naziv) from Bazeni

exec Bazeni_Update '9', 'SPC Vojvodina', '5'
exec Bazen_Insert 'Diamond Garden', '1'
exec Bazeni_Delete 'Diamond Garden', '1'
exec Ukupno_Bazeni
select * from Bazeni

--termini

alter PROC Termini_Insert
@tip_karte_id int,
@pocetak_termina time,
@kraj_termina time  
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 tip_karte_id, pocetak_termina  FROM Termini
	WHERE tip_karte_id=@tip_karte_id and pocetak_termina=@pocetak_termina and kraj_termina=@kraj_termina)
	Return 1
	else
	Insert Into Termini(tip_karte_id, pocetak_termina, kraj_termina)
	Values(@tip_karte_id, @pocetak_termina, @kraj_termina)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

alter PROC Termini_Update
@id int,
@tip_karte_id int,
@pocetak_termina time,
@kraj_termina time 
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 tip_karte_id, pocetk_termina FROM Termini
	WHERE id = @id)
	BEGIN
	Update Termini Set tip_karte_id=@tip_karte_id, pocetak_termina=@pocetak_termina, kraj_termina=@kraj_termina where id=@id
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create Proc Termini_Delete
@tip_karte_id int,
@pocetak_termina time,
@kraj_termina time 
as
Begin TRY
Delete from Termini where tip_karte_id=@tip_karte_id and pocetak_termina=@pocetak_termina and kraj_termina=@kraj_termina
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

create PROC Ukupno_Termini
as
select count(id) from Termini

exec Termini_Insert '5', '18:00', '20:00'
exec Termini_Update '2', '2', '15:00', '16:00:00'
exec Termini_Delete '5', '18:00', '20:00'
exec Ukupno_Termini
select * from Termini

--iznajmljivanje

create PROC Iznajmljivanje_Insert
@korisnik_id int,
@termin_id int,
@datum date,
@bazen_id int 
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
IF EXISTS (SELECT TOP 1 korisnik_id, termin_id, bazen_id  FROM Iznajmljivanje
	WHERE korisnik_id=@korisnik_id and termin_id=@termin_id and datum=@datum and bazen_id=@bazen_id)
	Return 1
	else
	Insert Into Iznajmljivanje(korisnik_id, termin_id, datum, bazen_id)
	Values(@korisnik_id, @termin_id, @datum, @bazen_id)
		RETURN 0;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

create PROC Iznajmljivanje_Update
@id int,
@korisnik_id int,
@termin_id int,
@datum date,
@bazen_id int  
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
	IF EXISTS (SELECT TOP 1 korisnik_id, termin_id, bazen_id FROM Iznajmljivanje
	WHERE id = @id)
	BEGIN
	Update Iznajmljivanje Set korisnik_id=@korisnik_id, termin_id=@termin_id, datum=@datum, bazen_id=@bazen_id where id=@id
		RETURN 0;
	END
	RETURN -1;
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

Create Proc Iznajmljivanje_Delete
@korisnik_id int,
@termin_id int,
@datum date,
@bazen_id int  
as
Begin TRY
Delete from Iznajmljivanje where korisnik_id=@korisnik_id and termin_id=@termin_id and datum=@datum and bazen_id=@bazen_id
RETURN 0
END TRY
BEGIN CATCH
	RETURN @@ERROR;
END CATCH

create PROC Ukupno_Iznajmljivanje
as
select count(id) from Iznajmljivanje

exec Iznajmljivanje_Insert '4', '2', '05-03-2022', '3'
exec Iznajmljivanje_Update 1, '2', '2', '05-03-2022', '3'
exec Iznajmljivanje_Delete '4', '2', '05-03-2022', '3'
exec Ukupno_Iznajmljivanje
select * from Iznajmljivanje