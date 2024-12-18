using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public abstract class SerializedPrimitive
    {
        public Enums.PrimitiveObjectType Type;
        public Vector3 Position;

        public SerializedPrimitive(Enums.PrimitiveObjectType type, Vector3 position)
        {
            this.Type = type;
            this.Position = position;
        }

        public abstract Primitive CreateInstance();
    }
}
