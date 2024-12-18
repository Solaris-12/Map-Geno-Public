using System.IO;
using System.Linq;
using Exiled.API.Features;
using MapGeno.API.Utils.Converters;
using Mirror;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Windows;
using static UnityEngine.RectTransform;

namespace MapGeno.API.Features.Map.Exporter
{
    internal class VanillaRoomExport
    {
        public static void RoomExporter(Room inputRoom, float accuracy, float backupRange = 0)
        {
            var roomSize = new Vector3(backupRange, backupRange, backupRange);
            if (backupRange == 0)
            {
                try
                {
                    var meshFilter = inputRoom.GetComponentInChildren<MeshFilter>();
                    roomSize = Matrix4x4.Scale(meshFilter.sharedMesh.bounds.size) * inputRoom.transform.localScale;
                }
                catch
                {
                    Log.Warn($"Room exporter WARN: not found Mesh filter, defaulting to backup range {backupRange}");
                }
            }
            
            var savedRotation = inputRoom.Rotation;
            inputRoom.transform.Rotate(0, 0, 0);

            var hitResults =
                Utils.Raycast.RaycastArea(inputRoom.Position, roomSize * 1.1f , accuracy);
            if (hitResults == null)
            {
                Log.Warn("Couldn't export raycast room: Invalid points");
                return;
            }

            Log.Info($"Room export is finishing with {hitResults.Count} hits!");
            var outputRoom = new VanillaCastRoom(inputRoom.RoomName.ToString(),
                hitResults.Select(e =>
                new RoomRaycastPoint(
                            Quaternion.AngleAxis(inputRoom.Rotation.y, Vector3.up) * (e.point - inputRoom.Position),
                            e.collider.name
                        )
                    ).ToList(),
                    accuracy
                );

            var json = JsonConvert.SerializeObject(outputRoom, Formatting.None, new Vector3Converter());
            File.WriteAllText(
                MapGeno.SingleTon.MapExportsFolderPath + $"{inputRoom.RoomName.ToString().ToLower()}-raycast.json",
                json);
            inputRoom.transform.Rotate(savedRotation.x, savedRotation.y, savedRotation.z);
            Log.Info($"Room export FINISHED!");
        }
    }
}
