using System;
using Exiled.API.Features;
using Exiled.API.Features.Items;
using UnityEngine;

// ReSharper disable InconsistentNaming

namespace MapGeno.API.Features.Objects
{
    public class PrimitiveItemSpawner : Primitive
    {
        public ItemType ItemType { get; set; }
        public Vector3 RoomPosition { get; set; }
        public Vector3 RoomRotation { get; set; }
        public Vector3 Rotation { get; set; }
        public Vector3 Scale { get; set; }
        public bool IsSetup { get; private set; } = false;

        public PrimitiveItemSpawner(Enums.PrimitiveObjectType type, Vector3 position, Vector3 rotation, Vector3 scale, string item_type, bool handleLocally = true) : base(type, position)
        {
            ItemType = ParseItemType(item_type);
            Rotation = rotation;
            Scale = scale;

            if (handleLocally)
                MapGeno.SingleTon.CreatedObjects.Add(this);
        }

        public override void Spawn(Vector3? roomPos = null, Vector3? roomRot = null)
        {
            var position = roomPos ?? Vector3.zero;
            var rotation = roomRot ?? Vector3.zero;

            RoomPosition = position;
            RoomRotation = rotation;
            if (Round.InProgress)
            {
                HandleItemSpawn();
                return;
            }
            if (IsSetup) return;

            Exiled.Events.Handlers.Server.RoundStarted += HandleItemSpawn;
            IsSetup = true;
        }

        public override void DeSpawn()
        {
            if (!IsSetup) return;

            Exiled.Events.Handlers.Server.RoundStarted -= HandleItemSpawn;
            IsSetup = false;
        }

        private void HandleItemSpawn()
        {
            var item = Item.Create(this.ItemType);
            item.Scale = this.Scale;

            var pickup = item.CreatePickup(this.RoomPosition + this.RelativePosition, Quaternion.Euler(this.Rotation));

            if (pickup.IsSpawned)
            {
                pickup.UnSpawn();
                pickup.GameObject.transform.RotateAround(this.RoomPosition, Vector3.up, this.RoomRotation.y);
            }
            else
            {
                pickup.GameObject.transform.RotateAround(this.RoomPosition, Vector3.up, this.RoomRotation.y);
            }
            pickup.Spawn();
        }

        private static ItemType ParseItemType(string name)
        {
            return (ItemType)Enum.Parse(typeof(ItemType), name);
        }
    }
}
