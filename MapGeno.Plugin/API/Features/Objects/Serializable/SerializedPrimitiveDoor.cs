using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Exiled.API.Enums;
using MapGeno.API.Enums;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitiveDoor: SerializedPrimitive
    {

        public FacilityDoorType DoorType;
        public Vector3 Rotation;
        public Vector3 Scale;
        public bool IsOpen;
        public bool Allow106;
        public DoorLockType LockType;
        public KeycardPermissions Permissions;

        public SerializedPrimitiveDoor(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, string door_type, bool is_open, bool allow_106, int lock_type, int permissions) : base(type, position)
        {
            this.DoorType = ParseDoorType(door_type);
            this.Rotation = rotation;
            this.Scale = scale;
            this.IsOpen = is_open;
            this.Allow106 = allow_106;
            this.LockType = (DoorLockType)lock_type;
            this.Permissions = (KeycardPermissions)permissions;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitiveDoor(this.Type, this.Position, this.Rotation, this.Scale)
            {
                DoorType = this.DoorType,
                IsOpen = this.IsOpen,
                Allow106 = this.Allow106,
                LockType = this.LockType,
                Permissions = this.Permissions,
            };
        }
        
        private static FacilityDoorType ParseDoorType(string name)
        {
            return (FacilityDoorType)Enum.Parse(typeof(FacilityDoorType), name);
        }
    }
}
