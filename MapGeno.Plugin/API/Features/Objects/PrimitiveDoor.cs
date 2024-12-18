using AdminToys;
using Mirror;
using System;
using System.Collections.Generic;
using System.Linq;
using Exiled.API.Enums;
using Exiled.API.Features;
using Exiled.API.Features.Doors;
using Interactables.Interobjects.DoorUtils;
using MapGeneration;
using MapGeno.API.Enums;
using MapGeno.API.Features.Objects;
using UnityEngine;
using Utf8Json.Internal.DoubleConversion;
using Newtonsoft.Json.Linq;
using PluginAPI.Core;
using KeycardPermissions = Exiled.API.Enums.KeycardPermissions;
using Object = UnityEngine.Object;

namespace MapGeno.API.Features.Objects
{
    public class PrimitiveDoor: Primitive
    {
        public FacilityDoorType DoorType
        {
            get => this._doorType;
            set
            {
                this._doorType = value;
                this.Update();
            }
        }
        public new Vector3 RelativePosition
        {
            get => this._position;
            set
            {
                this._position = value;
                if (this.Toy == null) return;
                this.Toy.Position = value;
            }
        }
        public Vector3 Rotation
        {
            get => this._rotation;
            set
            {
                this._rotation = value;
                if (Toy == null) return;
                this.Toy.Rotation = Quaternion.Euler(value);
            }
        }
        public Vector3 Scale
        {
            get => this._scale;
            set
            {
                this._scale = value;
                if (Toy == null) return;
                this.Toy.Scale = value;
            }
        }

        public bool Allow106
        {
            get => this._allow106;
            set
            {
                this._allow106 = value;
                if (Toy == null) return;
                Toy.AllowsScp106 = value;
            }
        }
        
        public bool IsOpen
        {
            get => this._isOpen;
            set
            {
                this._isOpen = value;
                if (Toy == null) return;
                Toy.IsOpen = value;
            }
        }

        public DoorLockType LockType
        {
            get => this._lockType;
            set
            {
                this._lockType = value;
                this.Toy?.ChangeLock(value);
            }
        }
        
        public KeycardPermissions Permissions
        {
            get => this._permissions;
            set
            {
                this._permissions = value;
                if (Toy == null) return;
                Toy.KeycardPermissions = value;
            }
        }
        
        public new Door Toy { get; private set; }
        public bool IsSpawned { get; private set; } = false;

        private Vector3 _position;
        private Vector3 _rotation;
        private Vector3 _scale;
        private FacilityDoorType _doorType;
        private bool _allow106;
        private bool _isOpen;
        private DoorLockType _lockType;
        private KeycardPermissions _permissions;
        

        private Vector3 _offsetPosition;
        private Vector3 _offsetRotation;

        public PrimitiveDoor(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, bool handleLocally = true): base(type, position)
        {
            this.RelativePosition = position;
            this.Rotation = rotation;
            this.Scale = scale;
            
            if (handleLocally)
                MapGeno.SingleTon.CreatedObjects.Add(this);
        }

        /// <inheritdoc cref="Primitive.Spawn"/>
        public override void Spawn(Vector3? pos = null, Vector3? rot = null)
        {
            this._offsetPosition = pos ?? Vector3.zero;
            this._offsetRotation = rot ?? Vector3.zero;

            this.Update();
            this.IsSpawned = true;
        }

        private void Update()
        {
            if (this.IsSpawned && this.Toy != null)
            {
                NetworkServer.UnSpawn(this.Toy.GameObject);
            }
            
            var doors = Object.FindObjectsOfType<DoorSpawnpoint>();
            var existingDoorSpawnpoint = doors.First(x => x.TargetPrefab.name.Contains(EnumsUtils.FacilityDoorTypeToPrefabs(this._doorType)));
            var doorVariantObj = UnityEngine.Object.Instantiate(existingDoorSpawnpoint.TargetPrefab.gameObject);
            if (doorVariantObj.TryGetComponent<DoorVariant>(out var doorVariant))
            {
                var door = Door.Get(doorVariant);
                door.Position = this.RelativePosition + this._offsetPosition;
                door.Rotation = Quaternion.Euler(this.Rotation + this._offsetRotation);
                door.Scale = this.Scale;
                door.AllowsScp106 = _allow106;
                door.IsOpen = _isOpen;
                door.ChangeLock(_lockType);
                door.KeycardPermissions = _permissions;
                this.Toy = door;
                NetworkServer.Spawn(this.Toy.GameObject);
            }
        }

        /// <inheritdoc cref="Primitive.DeSpawn"/>
        public override void DeSpawn()
        {
            if (this.Toy == null) return;
            NetworkServer.Destroy(this.Toy.GameObject);
            this.Toy = null;

            this.IsSpawned = false;
        }
    }
}
