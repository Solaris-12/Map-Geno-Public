using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitiveObject : SerializedPrimitive
    {

        public Vector3 Rotation;
        public Vector3 Scale;
        public Color Color;
        public bool CanCollide = true;

        public SerializedPrimitiveObject(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, Color color, bool can_collide = true) : base(type, position)
        {
            this.Rotation = rotation;
            this.Scale = scale;
            this.Color = color;
            this.CanCollide = can_collide;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitiveObject(this.Type, this.Position, this.Rotation, this.Scale, this.Color, this.CanCollide);
        }
    }
}
