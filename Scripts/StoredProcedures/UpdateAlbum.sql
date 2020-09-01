if exists (select * from INFORMATION_SCHEMA.ROUTINES where Routine_name = 'UpdateAlbum')
begin
	DROP PROCEDURE [dbo].[UpdateAlbum]
end
go

CREATE PROCEDURE [dbo].[UpdateAlbum]
	(	
		@Id int,
		@Name nvarchar(200),
		@Artist nvarchar(200),
		@Label nvarchar(200),
		@TypeId int,
		@Stock int
	)
As
	Update Album Set 	Name = @Name, Artist = @Artist, Label = @Label, TypeId = @TypeId, Stock = @Stock where Id = @Id
	IF @@ROWCOUNT = 0
	BEGIN
		RAISERROR('The record does not exist to update', 18, 0)
	END
go
