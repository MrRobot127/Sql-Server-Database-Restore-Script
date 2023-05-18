
	USE master;
	GO
		DECLARE @DatabaseName NVARCHAR(100) = 'SanjeevStockissue'
		DECLARE @BackupFilePath NVARCHAR(1000) = 'D:\Surendra_Backup\girish.bak'
		DECLARE @DataFileLocation NVARCHAR(1000) = 'D:\Surendra_MDAFile\DataFile3.mdf'
		DECLARE @LogFileLocation NVARCHAR(1000) = 'D:\Surendra_MDAFile\LogFile3.ldf'
		DECLARE @LogicalDataFileName NVARCHAR(128)
		DECLARE @LogicalLogFileName NVARCHAR(128)
		DECLARE @SqlStatement NVARCHAR(MAX)

		-- Create a temporary table to store the file list
		CREATE TABLE #FileList (
			LogicalName NVARCHAR(128),
			PhysicalName NVARCHAR(260),
			[Type] CHAR(1),
			FileGroupName NVARCHAR(128),
			Size DECIMAL(20,0),
			MaxSize DECIMAL(20,0),
			FileId BIGINT,
			CreateLSN DECIMAL(25,0),
			DropLSN DECIMAL(25,0),
			UniqueId UNIQUEIDENTIFIER,
			ReadOnlyLSN DECIMAL(25,0),
			ReadWriteLSN DECIMAL(25,0),
			BackupSizeInBytes BIGINT,
			SourceBlockSize INT,
			FileGroupId INT,
			LogGroupGUID UNIQUEIDENTIFIER,
			DifferentialBaseLSN DECIMAL(25,0),
			DifferentialBaseGUID UNIQUEIDENTIFIER,
			IsReadOnly BIT,
			IsPresent BIT,
			TDEThumbprint VARBINARY(32)
		)

		-- Get the logical file names from the backup file
		INSERT INTO #FileList
		EXEC('RESTORE FILELISTONLY
		FROM DISK = ''' + @BackupFilePath + '''');

		-- Assign the logical file names to variables
		SELECT @LogicalDataFileName = LogicalName FROM #FileList WHERE [Type] = 'D'
		SELECT @LogicalLogFileName = LogicalName FROM #FileList WHERE [Type] = 'L'

		-- Drop the temporary table
		DROP TABLE #FileList

		SET @SqlStatement = N'
		ALTER DATABASE ' + QUOTENAME(@DatabaseName) + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE ' + QUOTENAME(@DatabaseName) + N';			
		RESTORE DATABASE ' + QUOTENAME(@DatabaseName) + N'
		FROM DISK = ' + QUOTENAME(@BackupFilePath, '''') + N'
		WITH
			MOVE ' + QUOTENAME(@LogicalDataFileName, '''') + N' TO ' + QUOTENAME(@DataFileLocation, '''') + N',
			MOVE ' + QUOTENAME(@LogicalLogFileName, '''') + N' TO ' + QUOTENAME(@LogFileLocation, '''') + N'
		';

		PRINT @SqlStatement
		EXEC sp_executesql @SqlStatement;

