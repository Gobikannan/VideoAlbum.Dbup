if object_id('dbo.AlbumType', 'U') is null
	create table dbo.AlbumType
	(
		Id int identity(1,1) not null,
		Name nvarchar(100) not null,
		CreatedOn datetime not null default getdate(),
		constraint pkAlbumTypeId primary key clustered (Id)
	)
go
