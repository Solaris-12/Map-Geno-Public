using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Features.Objects.Serializable
{
    public class SerializedPrimitiveLight : SerializedPrimitive
    {

        public float LightIntensity = 0;
        public float LightRange = 0;
        public Color LightColor;
        public bool LightShadows;

        public SerializedPrimitiveLight(Enums.PrimitiveObjectType type, Vector3 position, Color color,
            float light_intensity = 0, float light_range = 0, bool light_shadows = true) : base(type, position)
        {
            this.LightIntensity = light_intensity;
            this.LightRange = light_range;
            this.LightColor = color;
            this.LightShadows = light_shadows;
        }

        public override Primitive CreateInstance()
        {
            return new PrimitiveLight(this.Type, this.Position, this.LightColor, this.LightIntensity, this.LightRange, this.LightShadows);
        }
    }
}
