using DbUp;
using DbUp.Engine;
using DbUp.Helpers;
using System;
using System.Reflection;

namespace VideoAlbum.Dbup
{
    class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine("Initiating DB setup...");

            //For development purpose, I kept the connection string in the Application Arguments which is => Project settings -> Debug -> Application Arguments (VideoAlbum.Dbup\Properties\launchSettings.json)
            //so that, we can provide this args while automating the builds through Azure Release pipeline or Octopus through variables
            if (args.Length == 0)
            {
                throw new ArgumentNullException("ConnectionString");
            }
            var connectionString = args[0];

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentNullException(nameof(connectionString));
            }

            Console.WriteLine(connectionString);

            EnsureDatabase.For.SqlDatabase(connectionString);
            // this runs for Migrations only
            var migrationsUpgrader = DeployChanges.To.SqlDatabase(connectionString).WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly(), (x) => IsMigrationsScriptName(x) ).LogToConsole().Build();

            var result = migrationsUpgrader.PerformUpgrade();

            if (DisplayError(result))
            {
                return -1;
            }

            // we need to rerun storedprocedures, views, functions which has to recreate everytime 
            // we can avoid this by putting all SP, views, Funcs in Migrations folder but it's difficult to manage it when it grows bigger
            Console.WriteLine("Running scripts other than migrations..");

            var upgraderStoredProc = DeployChanges.To.SqlDatabase(connectionString)
                                .WithScriptsEmbeddedInAssembly(typeof(Program).Assembly, s => IsScriptsScriptName(s))
                                .JournalTo(new NullJournal())
                                .Build();

            var scriptsResult = upgraderStoredProc.PerformUpgrade();

            if (DisplayError(scriptsResult))
            {
                return -1;
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ReadLine();
            Console.ResetColor();
            return 0;
        }

        private static bool IsScriptsScriptName(string s)
        {
            return s.StartsWith("VideoAlbum.Dbup.Scripts.StoredProcedures") || s.StartsWith("VideoAlbum.Dbup.Scripts.Views") || s.StartsWith("VideoAlbum.Dbup.Scripts.Functions");
        }

        private static bool IsMigrationsScriptName(string s)
        {
            return s.StartsWith("VideoAlbum.Dbup.Migrations");
        }

        private static bool DisplayError(DatabaseUpgradeResult result)
        {
            // stop execution if it is failed for some reason and display the error
            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
#if DEBUG
                Console.ReadLine();
#endif
                return true;
            }

            return false;
        }
    }
}
