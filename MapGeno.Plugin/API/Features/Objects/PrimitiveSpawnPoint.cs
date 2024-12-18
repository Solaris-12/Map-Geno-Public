using System;
using System.Collections.Generic;
using Exiled.API.Features;
using MEC;
using PlayerRoles;
using UnityEngine;
// ReSharper disable InconsistentNaming

namespace MapGeno.API.Features.Objects
{
    public class PrimitiveSpawnPoint : Primitive
    {
        public RoleTypeId RoleType { get; set; }
        public Vector3 Rotation { get; set; }
        public Vector3 RoomPosition { get; set; }
        public Vector3 RoomRotation { get; set; }

        public PrimitiveSpawnPoint(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, string role_type = "") : base(type, position)
        {
            RoleType = ParseRoleType(role_type);
            Rotation = rotation;
        }

        public void PortPlayer(Player player)
        {
            Timing.RunCoroutine(PortPlayerCoroutine(player));
        }

        private IEnumerator<float> PortPlayerCoroutine(Player player)
        {
            yield return Timing.WaitForOneFrame;
            player.Teleport(this.RoomPosition + this.RelativePosition);
            yield return Timing.WaitForOneFrame;
            player.Rotation = Quaternion.Euler(this.Rotation);
            yield return Timing.WaitForOneFrame;
            player.Transform.RotateAround(this.RoomPosition, Vector3.up, this.RoomRotation.y);
        }

        /// <summary>
        /// Setups the position of the spawn-point
        /// </summary>
        public override void Spawn(Vector3? roomPos = null, Vector3? roomRot = null)
        {
            RoomPosition = roomPos ?? Vector3.zero;
            RoomRotation = roomRot ?? Vector3.zero;
            return;
        }

        /// <summary>
        /// Ignored...
        /// </summary>
        public override void DeSpawn()
        {
            return;
        }

        private static RoleTypeId ParseRoleType(string name)
        {
            return (RoleTypeId)Enum.Parse(typeof(RoleTypeId), name);
        }
    }
}
