using System;
using System.Linq;
using CommandSystem;
using Exiled.API.Features;
using Exiled.Permissions.Extensions;
using MapGeno.API.Features.Map.Exporter;
using RemoteAdmin;

namespace MapGeno.API.Commands
{
    [CommandHandler(typeof(ClientCommandHandler))]
    internal class ExportCurrentRoomCommand : ICommand
    {
        public string Command => "mgo_export_this";

        public string[] Aliases => null;

        public string Description => "[MAP-GENO] Exports current room using raycasts. | Usage: .mgo_export_this [accuracy] [backupRange]";
        
        public bool Execute(ArraySegment<string> arguments, ICommandSender sender, out string response)
        {
            response = "This command is disabled or you don't have permissions";

            if (!(sender is PlayerCommandSender commandSender)) return true;
            var player = Player.Get(commandSender.SenderId);

            if (!player.CheckPermission("solaris.map-geno.export")) return true;

            response = "You need to be within some room...";
            if (player.CurrentRoom == null) return true;

            var args = arguments.ToList();

            var accuracy = 0.41f;
            if (args.Count > 0 && float.TryParse(args[0], out accuracy)){}

            var backupRange = 0.0f;
            if (args.Count > 1 && float.TryParse(args[1], out backupRange)) { }

            VanillaRoomExport.RoomExporter(player.CurrentRoom, accuracy, backupRange);
            response = "Probably exported successfully!";
            return true;
        }
    }
}
