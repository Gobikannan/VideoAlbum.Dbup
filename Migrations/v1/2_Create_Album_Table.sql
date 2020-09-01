if object_id('dbo.Album', 'U') is null
	create table dbo.Album
	(
		Id int identity(1,1) not null,
		Name nvarchar(200) not null,
		Artist nvarchar(200) not null,
		Label nvarchar(200) not null,
		TypeId int not null,
		Stock int not null default 0,
		CreatedOn datetime not null default getdate(),
		constraint pkAlbumId primary key clustered (Id),
		constraint fkTypeIdAlbumTypeId foreign key (TypeId) references AlbumType(Id),
	)
go
