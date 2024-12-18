using System;
using System.Collections.Generic;
using System.Linq;
using Exiled.API.Features;
using MapGeneration;
using MapGeno.API.Features.Objects;
using MapGeno.API.Features.Objects.Serializable;

namespace MapGeno.API.Features.Map.Rooms
{
    public class CustomGameRoom
    {
        public RoomName RoomType { get; set; }
        public RoomMetadata Metadata { get; private set; }
        public List<SerializedPrimitive> RoomObjects { get; set; }
        public string FilePath { get; set; } = null;
        public List<Primitive> PrimitiveInstances { get; private set; }

        public CustomGameRoom(string name, List<SerializedPrimitive> data, RoomMetadata metadata = null)
        {
            this.RoomType = ParseRoomType(name);
            RoomObjects = data.Where(e => e != null).ToList();
            MapGeno.SingleTon.ImportedRooms.Add(this);
            PrimitiveInstances = new List<Primitive>();
            Metadata = metadata;
        }

        public void Spawn()
        {
            foreach (var room in Room.List.Where(r => r.RoomName == this.RoomType))
            {
                foreach (var primitiveObject in RoomObjects)
                {
                    var primitiveInstance = primitiveObject.CreateInstance();
                    primitiveInstance.Spawn(room.Position, room.Rotation.eulerAngles);
                    PrimitiveInstances.Add(primitiveInstance);
                }
            }
        }

        public void DeSpawn()
        {
            foreach (var primitiveInstance in PrimitiveInstances)
            {
                primitiveInstance.DeSpawn();
            }

            PrimitiveInstances.Clear();
        }

        private static RoomName ParseRoomType(string name)
        {
            return (RoomName)Enum.Parse(typeof(RoomName), name);
        }
    }
}
