using System;
using System.IO;
using Exiled.API.Features;
using MapGeno.API.Features.Map.Rooms;
using MapGeno.API.Utils.Converters;
using Newtonsoft.Json;

namespace MapGeno.API.Features.Map
{
    public class Loader
    {
        public static void LoadFromJsonFile(string jsonPath, bool shouldSpawn = true)
        {
            Loader.LoadRoomFromJsonFile(jsonPath, shouldSpawn);
        }

        public static CustomGameRoom LoadRoomFromJsonFile(string jsonPath, bool shouldSpawn = true)
        {
            try
            {
                using (var fileStream = File.Open(jsonPath, FileMode.Open, FileAccess.Read))
                using (var streamReader = new StreamReader(fileStream))
                {
                    var json = streamReader.ReadToEnd();
                    var room = LoadRoomFromJson(json, shouldSpawn);
                    room.FilePath = jsonPath;
                    return room;
                }
            }
            catch (Exception e)
            {
                Log.Warn($"Exception while reading ({jsonPath}) :\n{e}");
            }
            return null;
        }

        public static CustomGameRoom LoadRoomFromJson(string jsonData, bool shouldSpawn = true)
        {
            try
            {
                var room = JsonConvert.DeserializeObject<CustomGameRoom>(jsonData, new SerializedPrimitiveConverter(), new Vector3Converter(), new ColorConverter());
                if (shouldSpawn)
                    room.Spawn();
                return room;
            }
            catch (Exception e)
            {
                Log.Error($"Exception while loading: \n{e}");
            }

            return null;
        }
    }
}
