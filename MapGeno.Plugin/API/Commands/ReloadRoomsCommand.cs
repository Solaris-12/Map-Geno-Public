using CommandSystem;
using RemoteAdmin;
using System;
using System.Linq;
using Exiled.API.Features;
using Exiled.Permissions.Extensions;
using MapGeno.API.Features.Map.Importer;

namespace MapGeno.API.Commands
{
    [CommandHandler(typeof(ClientCommandHandler))]
    internal class ReloadRoomsCommand : ICommand
    {
        public string Command => "mgo_reload_all";

        public string[] Aliases => null;

        public string Description => "[MAP-GENO] Removes and imports back all custom rooms";

        public bool Execute(ArraySegment<string> arguments, ICommandSender sender, out string response)
        {
            response = "This command is disabled or you don't have permissions";

            if (!(sender is PlayerCommandSender commandSender)) return true;
            var player = Player.Get(commandSender.SenderId);

            if (!player.CheckPermission("solaris.map-geno.reload")) return true;

            response = "Something went wrong when reloading!";
            GlobalImporter.ImportAllRooms();

            var msg = MapGeno.SingleTon.ImportedRooms
                .Select(e => e.FilePath)
                .Aggregate("Imported rooms: \n", (current, data) => current + (data ?? "[HANDLED BY PLUGIN]") + "\n");
            response = $"Import was triggered, see server console for more info!\n {msg}";
            return true;
        }
    }
}
