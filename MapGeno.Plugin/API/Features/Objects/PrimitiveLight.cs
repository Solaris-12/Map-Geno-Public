using AdminToys;
using Mirror;
using System.Linq;
using UnityEngine;
// ReSharper disable InconsistentNaming

namespace MapGeno.API.Features.Objects
{
    public class PrimitiveLight : Primitive
    {

        public float LightIntensity
        {
            get => this._lightIntensity;
            set
            {
                this._lightIntensity = value;
                if (this.Toy == null) return;

                this.Toy.NetworkLightIntensity = value;
            }
        }
        public float LightRange
        {
            get => this._lightRange;
            set
            {
                this._lightRange = value;
                if (this.Toy == null) return;

                this.Toy.NetworkLightRange = value;
            }
        }
        public Color LightColor
        {
            get => this._lightColor;
            set
            {
                this._lightColor = value;
                if (this.Toy == null) return;

                this.Toy.NetworkLightColor = value;
            }
        }
        public bool LightShadow
        {
            get => this._lightShadows;
            set
            {
                this._lightShadows = value;
                if (this.Toy == null) return;

                this.Toy.NetworkLightShadows = value;
            }
        }
        public new LightSourceToy Toy { get; private set; }

        private float _lightIntensity = 0;
        private float _lightRange = 0;
        private Color _lightColor = Color.gray;
        private bool _lightShadows = true;

        public PrimitiveLight(Enums.PrimitiveObjectType type, Vector3 position, Color color, float light_intensity = 0, float light_range = 0, bool light_shadows = true, bool handleLocally = true) : base(type, position)
        {
            this.LightIntensity = light_intensity;
            this.LightRange = light_range;
            this.LightColor = color;
            this.LightShadow = light_shadows;

            if (handleLocally)
                MapGeno.SingleTon.CreatedObjects.Add(this);
        }

        /// <summary>
        /// Spawns the <see cref="Toy"/> into the world and synchronizes all values with clients
        /// </summary>
        /// <param name="roomPos">Offset position</param>
        /// <param name="roomRot">Offset rotation</param>
        public override void Spawn(Vector3? roomPos = null, Vector3? roomRot = null)
        {
            var position = roomPos ?? Vector3.zero;
            var rotation = roomRot ?? Vector3.zero;

            var gameObject = NetworkClient.prefabs.Values.ToList().Find(f => f.TryGetComponent<LightSourceToy>(out var _));
            if (gameObject == null) return;

            var primitiveObject = gameObject.GetComponent<LightSourceToy>();
            var newObject = UnityEngine.Object.Instantiate<LightSourceToy>(primitiveObject);
            NetworkServer.Spawn(newObject.gameObject);

            newObject.NetworkPosition = position + this.RelativePosition;
            newObject.NetworkLightIntensity = this.LightIntensity;
            newObject.NetworkLightRange = this.LightRange;
            newObject.NetworkLightColor = this.LightColor;
            newObject.NetworkLightShadows = this.LightShadow;
            newObject.NetworkMovementSmoothing = this.MotionSmoothing;

            newObject.transform.SetPositionAndRotation(newObject.NetworkPosition, newObject.NetworkRotation.Value);
            newObject.transform.localScale = newObject.NetworkScale;
            newObject.transform.RotateAround(position, Vector3.up, rotation.y);

            this.Toy = newObject;
        }
        
        /// <inheritdoc cref="Primitive.DeSpawn"/>
        public override void DeSpawn()
        {
            if (this.Toy == null) return;
            NetworkServer.Destroy(this.Toy.gameObject);
            this.Toy = null;
        }
    }
}
