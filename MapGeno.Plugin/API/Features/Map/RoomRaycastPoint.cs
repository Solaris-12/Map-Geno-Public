
using Newtonsoft.Json;
using System;
using UnityEngine;

namespace MapGeno.API.Features.Map
{
    public class RoomRaycastPoint
    {
        [JsonProperty(PropertyName = "position")]
        public Vector3 Position;
        [JsonProperty(PropertyName = "name")]
        public string Name;

        public RoomRaycastPoint(Vector3 position, string name)
        {
            this.Position = position;
            this.Name = name;
        }

        public static RoomRaycastPoint FromRaycastHit(RaycastHit hit)
        {
            return new RoomRaycastPoint(hit.point, hit.collider.name);
        }
    }
}
