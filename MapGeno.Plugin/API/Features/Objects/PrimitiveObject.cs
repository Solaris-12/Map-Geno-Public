using AdminToys;
using Mirror;
using System;
using System.Collections.Generic;
using System.Linq;
using Exiled.API.Enums;
using Exiled.API.Features;
using Interactables.Interobjects.DoorUtils;
using MapGeno.API.Features.Objects;
using UnityEngine;
using Utf8Json.Internal.DoubleConversion;
using Newtonsoft.Json.Linq;

namespace MapGeno.API.Features.Objects
{
    public class PrimitiveObject: Primitive
    {
        public new Vector3 RelativePosition
        {
            get => this._position;
            set
            {
                this._position = value;
                if (this.Toy == null) return;
                this.Toy.NetworkPosition = value;
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
                Toy.NetworkRotation = new LowPrecisionQuaternion(Quaternion.Euler(value));
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
                Toy.NetworkScale = value;
                this.Toy.transform.localScale = value;
            }
        }
        public Color Color
        {
            get => this._color;
            set
            {
                this._color = value;
                if (Toy == null) return;
                Toy.NetworkMaterialColor = value;
            }
        }

        /// <summary>
        /// If the object can be collided with
        /// </summary>
        public bool CanCollide
        {
            get => this._canCollide;
            set
            {
                this._canCollide = value;
                if (Toy == null) return;

                var collider = this.Toy.gameObject.GetComponentInChildren<Collider>();
                if (collider == null) return;
                collider.enabled = value;
            }
        }
        public new PrimitiveObjectToy Toy { get; private set; }
        public bool IsSpawned { get; private set; } = false;

        private Vector3 _position;
        private Vector3 _rotation;
        private Vector3 _scale;
        private Color _color;
        private bool _canCollide;

        public PrimitiveObject(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, Color color, bool canCollide = true, bool handleLocally = true): base(type, position)
        {
            this.RelativePosition = position;
            this.Rotation = rotation;
            this.Scale = scale;
            this.Color = color;
            this.CanCollide = canCollide;

            if (handleLocally)
                MapGeno.SingleTon.CreatedObjects.Add(this);
        }

        /// <inheritdoc cref="Primitive.Spawn"/>
        public override void Spawn(Vector3? pos = null, Vector3? rot = null)
        {
            var position = pos ?? Vector3.zero;
            var rotation = rot ?? Vector3.zero;

            var gameObject = NetworkClient.prefabs.Values.ToList().Find(f => f.TryGetComponent<PrimitiveObjectToy>(out var _));
            if (gameObject == null) return;

            var primitiveObject = gameObject.GetComponent<PrimitiveObjectToy>();
            var newObject = UnityEngine.Object.Instantiate<PrimitiveObjectToy>(primitiveObject);
            NetworkServer.Spawn(newObject.gameObject);

            newObject.NetworkPosition = position + this.RelativePosition;
            newObject.NetworkRotation = new LowPrecisionQuaternion(Quaternion.Euler(this.Rotation));
            newObject.NetworkScale = this.Scale;
            newObject.NetworkPrimitiveType = EnumsUtils.PrimitiveObjectType_TO_PrimitiveType(this.Type);
            newObject.NetworkMaterialColor = this.Color;
            newObject.NetworkMovementSmoothing = this.MotionSmoothing;

            newObject.transform.SetPositionAndRotation(newObject.NetworkPosition, newObject.NetworkRotation.Value);
            newObject.transform.localScale = newObject.NetworkScale;
            newObject.transform.RotateAround(position, Vector3.up, rotation.y);

            this.Toy = newObject;
            var collider = this.Toy.gameObject.GetComponentInChildren<Collider>();
            if (collider != null)
            {
                collider.enabled = this.CanCollide;
            }

            this.IsSpawned = true;
        }

        /// <inheritdoc cref="Primitive.DeSpawn"/>
        public override void DeSpawn()
        {
            if (this.Toy == null) return;
            NetworkServer.Destroy(this.Toy.gameObject);
            this.Toy = null;

            this.IsSpawned = false;
        }
        
        public override string ToString()
        {
            return $"PrimitiveObject (TYPE: {this.Type}; POS: {this.RelativePosition}; ROT: {this.Rotation}; SCL: {this.Scale}; CLR: {this.Color})";
        }
    }
}
