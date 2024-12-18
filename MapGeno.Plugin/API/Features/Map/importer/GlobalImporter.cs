using System.IO;
using System.Linq;
using Exiled.API.Features;

namespace MapGeno.API.Features.Map.Importer
{
    public class GlobalImporter
    {
        public static void ImportAllRooms(bool removeExisting = true)
        {
            // Remove already imported rooms
            if (removeExisting)
                DespawnAllImportedObjects();

            // Importing stuff
            var allFiles = Directory.GetFiles(MapGeno.SingleTon.MapImportsFolderPath);
            var filteredFiles = allFiles.ToList().Where(file => file.EndsWith(".json"));
            foreach (var file in filteredFiles)
            {
                Features.Map.Loader.LoadFromJsonFile(file, true);
            }
            Log.Info("[RoomImporter] Everything imported!");
        }

        public static void DespawnAllImportedObjects()
        {
            foreach (var importedRoom in MapGeno.SingleTon.ImportedRooms)
            {
                importedRoom.DeSpawn();
            }
        }
    }
}