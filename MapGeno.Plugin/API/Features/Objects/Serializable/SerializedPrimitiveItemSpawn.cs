using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitiveItemSpawn: SerializedPrimitive
    {

        public string ItemType;
        public Vector3 Rotation;
        public Vector3 Scale;

        public SerializedPrimitiveItemSpawn(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, string item_type) : base(type, position)
        {
            this.ItemType = item_type;
            this.Rotation = rotation;
            this.Scale = scale;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitiveItemSpawner(this.Type, this.Position, this.Rotation, this.Scale, this.ItemType);
        }
    }
}
