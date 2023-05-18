# Database Restore Script

This script restores a SQL Server database from a backup file using the provided backup file path. It sets the target database to single-user mode, drops the existing database if it exists, and then restores the database from the backup file to the specified data and log file locations.

## Prerequisites

- SQL Server instance installed
- Sufficient permissions to execute the script
- Backup file (`.bak`) of the database

## Usage

1. Modify the script variables at the beginning of the script:
   - `@DatabaseName`: Specify the name of the database to be restored.
   - `@BackupFilePath`: Provide the full path of the backup file.
   - `@DataFileLocation`: Specify the desired location for the data file (.mdf).
   - `@LogFileLocation`: Specify the desired location for the log file (.ldf).

2. Execute the script in SQL Server Management Studio or any other SQL query tool.

Please note that this script drops the existing database with the specified name and restores it from the backup file. Make sure to double-check the database name and file locations before executing the script.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
