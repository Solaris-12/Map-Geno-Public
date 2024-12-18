using System.Collections.Generic;
using System.IO;
using Exiled.API.Enums;
using Exiled.API.Features;
using MapGeno.API;
using MapGeno.API.Features.Map.Rooms;
using MapGeno.API.Features.Objects;

namespace MapGeno
{
    /// <inheritdoc />
    public class MapGeno : Plugin<Config>
    {
        /// <inheritdoc />
        public override PluginPriority Priority => PluginPriority.Low;
        /// <inheritdoc />
        public override string Name => "Solaris-Map-Geno";
        /// <inheritdoc />
        public override string Author => "Solaris-12 + Contributors";
        public string MapsFolderPath => Path.GetDirectoryName(ConfigPath) + "/maps/";
        public string MapExportsFolderPath => Path.GetDirectoryName(ConfigPath) + "/maps/exports/";
        public string MapImportsFolderPath => Path.GetDirectoryName(ConfigPath) + "/maps/imports/";
        public List<CustomGameRoom> ImportedRooms { get; private set; } = new List<CustomGameRoom>();
        public List<Primitive> CreatedObjects = new List<Primitive>();

        public EventHandler EventHandlers;

        public static MapGeno SingleTon;

        public override void OnEnabled()
        {
            SingleTon = this;

            EventHandlers = new EventHandler();
            Exiled.Events.Handlers.Server.WaitingForPlayers += EventHandlers.OnWaitingForPlayers;
            Exiled.Events.Handlers.Server.RestartingRound += EventHandlers.OnRestartingRound;

            Exiled.Events.Handlers.Player.ChangingRole += EventHandlers.OnPlayerChangingRole;


            Log.Info($"{Name} has loaded!");

            if (!Directory.Exists(MapsFolderPath))
            {
                Directory.CreateDirectory(MapsFolderPath);

                if (!Directory.Exists(MapExportsFolderPath))
                    Directory.CreateDirectory(MapExportsFolderPath);
                if (!Directory.Exists(MapImportsFolderPath))
                    Directory.CreateDirectory(MapImportsFolderPath);
            }

            base.OnEnabled();
        }
        public override void OnDisabled()
        {
            Log.Info($"{Name} is unloading");

            Exiled.Events.Handlers.Server.WaitingForPlayers -= EventHandlers.OnWaitingForPlayers;
            Exiled.Events.Handlers.Server.RestartingRound -= EventHandlers.OnRestartingRound;

            Exiled.Events.Handlers.Player.ChangingRole -= EventHandlers.OnPlayerChangingRole;

            base.OnDisabled();
        }
    }
}
