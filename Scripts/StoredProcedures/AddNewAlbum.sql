if exists (select * from INFORMATION_SCHEMA.ROUTINES where Routine_name = 'AddNewAlbum')
begin
	DROP PROCEDURE [dbo].[AddNewAlbum]
end
go

CREATE PROCEDURE [dbo].[AddNewAlbum]
	(		
		@Name nvarchar(200),
		@Artist nvarchar(200),
		@Label nvarchar(200),
		@TypeId int,
		@Stock int
	)
As
	Insert into Album(Name, Artist, Label, TypeId, Stock) 
				Values (@Name, @Artist, @Label, @TypeId, @Stock)
go
