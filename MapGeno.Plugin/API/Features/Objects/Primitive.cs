using AdminToys;
using Mirror;
using System;
using System.Collections.Generic;
using System.Linq;
using Exiled.API.Features;
using MapGeno.API.Features.Objects;
using UnityEngine;
using Utf8Json.Internal.DoubleConversion;

namespace MapGeno.API.Features.Objects
{
    /// <summary>
    /// Very basic object that can be <see cref="Primitive.Spawn"/>ed into the world
    /// </summary>
    public abstract class Primitive
    {
        /// <summary>
        /// Get the type of the object type imputed...
        /// You can use <see cref="Activator.CreateInstance"/> to create instance from this type!
        /// </summary>
        /// <param name="type"></param>
        /// <returns>Returns typeof <see cref="Primitive"/> based on <see cref="Enums.PrimitiveObjectType"/> inputed</returns>
        /// <exception cref="ArgumentOutOfRangeException">When unknown type inputed</exception>
        public static Type FromObjectType(Enums.PrimitiveObjectType type)
        {
            switch (type)
            {
                case Enums.PrimitiveObjectType.Cube:
                case Enums.PrimitiveObjectType.Sphere:
                case Enums.PrimitiveObjectType.Capsule:
                case Enums.PrimitiveObjectType.Cylinder:
                case Enums.PrimitiveObjectType.Plane:
                    return typeof(PrimitiveObject);
                case Enums.PrimitiveObjectType.Light:
                    return typeof(PrimitiveLight);
                case Enums.PrimitiveObjectType.Prefab:
                    return typeof(PrimitivePrefab);
                case Enums.PrimitiveObjectType.ItemSpawn:
                    return typeof(PrimitiveItemSpawner);
                case Enums.PrimitiveObjectType.SpawnPoint:
                    return typeof(PrimitiveSpawnPoint);
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), type, null);
            }
        }

        /// <summary>
        /// The type of the object, <see cref="Enums.PrimitiveObjectType"/>
        /// </summary>
        public Enums.PrimitiveObjectType Type { get; private set; }

        /// <summary>
        /// Position of the object / Relative position to the room position (depends on usage)
        /// </summary>
        public Vector3 RelativePosition
        {
            get => this._position;
            set
            {
                this._position = value;
                if (this.Toy == null) return;
                this.Toy.NetworkPosition = value;
                this.Toy.transform.SetPositionAndRotation(value, new Quaternion(0,0,0,0));
            }
        }
        
        /// <summary>
        /// Controls the rate of interpolation for the object's position, rotation, and scale towards their target values. Used for smooth transitions between old and new values
        /// </summary>
        public byte MotionSmoothing
        {
            get => this._motionSmoothing;
            set
            {
                this._motionSmoothing = value;
                if (this.Toy == null) return;
                this.Toy.NetworkMovementSmoothing = value;
            }
        }
        public AdminToyBase Toy { get; private set; }

        private Vector3 _position;
        private byte _motionSmoothing;

        protected Primitive(Enums.PrimitiveObjectType type, Vector3 position)
        {
            this.Toy = null;
            this.Type = type;
            this.RelativePosition = position;
        }

        /// <summary>
        /// Spawns the <see cref="Toy"/> into the world and synchronizes all values with clients
        /// </summary>
        /// <param name="pos">Offset position</param>
        /// <param name="rot">Offset rotation</param>
        public abstract void Spawn(Vector3? pos = null, Vector3? rot = null);

        /// Removes the <see cref="Toy"/> from the world
        public abstract void DeSpawn();

        public override string ToString()
        {
            return $"Primitive (TYPE: {this.Type}; POS: {this.RelativePosition})";
        }
    }
}
