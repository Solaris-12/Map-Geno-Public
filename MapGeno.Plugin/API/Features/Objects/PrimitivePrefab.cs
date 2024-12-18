using Mirror;
using System;
using System.Linq;
using Exiled.API.Features;
using UnityEngine;
// ReSharper disable InconsistentNaming

namespace MapGeno.API.Features.Objects
{
    public class PrimitivePrefab : Primitive
    {
        public new Vector3 RelativePosition
        {
            get => this._position;
            set
            {
                this._position = value;
                if (this.Toy == null) return;
                this.Toy.transform.SetPositionAndRotation(value, Quaternion.Euler(this.Rotation));
            }
        }
        public Vector3 Rotation
        {
            get => this._rotation;
            set
            {
                this._rotation = value;
                if (Toy == null) return;
                this.Toy.transform.SetPositionAndRotation(this.RelativePosition, Quaternion.Euler(value));
            }
        }
        public Vector3 Scale
        {
            get => this._scale;
            set
            {
                this._scale = value;
                if (Toy == null) return;
                this.Toy.transform.localScale = value;
            }
        }
        public string PrefabType { get; set; }
        public new GameObject Toy { get; private set; }

        private Vector3 _position;
        private Vector3 _rotation;
        private Vector3 _scale;

        public PrimitivePrefab(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, string prefab_type = "", bool handleLocally = true) : base(type, position)
        {
            this.RelativePosition = position;
            this.PrefabType = prefab_type;
            this.Rotation = rotation;
            this.Scale = scale;

            if (handleLocally)
                MapGeno.SingleTon.CreatedObjects.Add(this);
        }

        /// <inheritdoc cref="Primitive.Spawn"/>
        public override void Spawn(Vector3? roomPos = null, Vector3? roomRot = null)
        {
            var position = roomPos ?? Vector3.zero;
            var rotation = roomRot ?? Vector3.zero;

            var gameObject = NetworkClient.prefabs.Values.ToList()
                .Find(f => string.Equals(f.name, this.PrefabType, StringComparison.CurrentCultureIgnoreCase));

            if (gameObject == null)
            {
                Log.Warn($"[SPAWN-PREFAB] Couldn't find '{PrefabType}' in prefabs");
                return;
            }

            // DEBUG
            //var components = gameObject.GetComponents(typeof(Component));
            //foreach (var component in components)
            //{
            //    Log.Debug($"Prefab component for {PrefabType}: {component}");
            //}

            // Spawning
            var newObject = UnityEngine.Object.Instantiate(gameObject);
            NetworkServer.Spawn(newObject);

            newObject.transform.SetPositionAndRotation(position + this.RelativePosition, Quaternion.Euler(this.Rotation));
            newObject.transform.localScale = this.Scale;
            newObject.transform.RotateAround(position, Vector3.up, rotation.y);

            this.Toy = newObject;
        }

        /// <inheritdoc cref="Primitive.DeSpawn"/>
        public override void DeSpawn()
        {
            if (this.Toy == null) return;
            NetworkServer.Destroy(this.Toy);
            this.Toy = null;
        }
    }
}
