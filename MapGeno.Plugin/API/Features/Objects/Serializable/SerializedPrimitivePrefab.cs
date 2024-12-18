using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitivePrefab: SerializedPrimitive
    {

        public string PrefabType;
        public Vector3 Rotation;
        public Vector3 Scale;

        public SerializedPrimitivePrefab(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, string prefab_type) : base(type, position)
        {
            this.PrefabType = prefab_type;
            this.Rotation = rotation;
            this.Scale = scale;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitivePrefab(this.Type, this.Position, this.Rotation, this.Scale, this.PrefabType);
        }
    }
}
