using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitiveSpawnPoint: SerializedPrimitive
    {

        public string RoleType;
        public Vector3 Rotation;

        public SerializedPrimitiveSpawnPoint(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, string role_type) : base(type, position)
        {
            this.RoleType = role_type;
            this.Rotation = rotation;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitiveSpawnPoint(this.Type, this.Position, this.Rotation, this.RoleType);
        }
    }
}
