using System.Linq;
using Exiled.API.Features;
using Exiled.Events.EventArgs.Player;
using MapGeno.API.Enums;
using MapGeno.API.Features.Map.Importer;
using MapGeno.API.Features.Objects;
using MEC;
using PlayerRoles;
using Random = UnityEngine.Random;

namespace MapGeno
{
    public class EventHandler
    {
        // Event handlers

        public void OnWaitingForPlayers()
        {
            GlobalImporter.ImportAllRooms();
        }

        public void OnRestartingRound()
        {
            GlobalImporter.DespawnAllImportedObjects();
        }

        public void OnPlayerChangingRole(ChangingRoleEventArgs ev)
        {
            if (!Round.InProgress) return;

            Timing.CallDelayed(0.1f, () =>
            {
                if (ev?.Player == null) return;
                if (ev.Player.CurrentRoom == null) return;

                var customRooms = MapGeno.SingleTon.ImportedRooms.Where(r => r.RoomType == ev.Player.CurrentRoom.RoomName);


                foreach (var customRoom in customRooms)
                {
                    var spawnPoints = customRoom.PrimitiveInstances
                        .Where(pi => pi.Type == PrimitiveObjectType.SpawnPoint)
                        .Select(s => (PrimitiveSpawnPoint)s)
                        .Where(swp => swp.RoleType == ev.NewRole)
                        .ToList();

                    if (spawnPoints.Count <= 0) return;
                    if (spawnPoints.Count == 1)
                    {
                        var spawnPoint = spawnPoints[0];
                        spawnPoint.PortPlayer(ev.Player);
                        return;
                    }

                    var randomSpawnPoint = spawnPoints[Random.Range(0, spawnPoints.Count)];
                    randomSpawnPoint.PortPlayer(ev.Player);
                }
            });
        }
    }
}
