IF EXISTS(select 1 from sys.views where name='FetchAllAlbumType' and type='v')
	DROP VIEW [dbo].[FetchAllAlbumType];
GO

CREATE VIEW [dbo].[FetchAllAlbumType]
AS
	SELECT Id, Name 
	  FROM dbo.AlbumType
GO
