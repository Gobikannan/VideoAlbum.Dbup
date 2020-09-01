if exists (select * from INFORMATION_SCHEMA.ROUTINES where Routine_name = 'DeleteAlbum')
begin
	DROP PROCEDURE [dbo].[DeleteAlbum]
end
go

CREATE PROCEDURE [dbo].DeleteAlbum
	(	
		@Id int
	)
As
	-- ideally this is not required as this would be handled on API
	IF (ISNULL(@Id, 0) = 0)
	BEGIN
		RAISERROR('Invalid parameter: @Id cannot be NULL or zero', 18, 0)
		RETURN
	END

	Delete from Album where Id = @Id

	IF @@ROWCOUNT = 0
	BEGIN
		RAISERROR('The record does not exist to delete', 18, 0)
	END
go
