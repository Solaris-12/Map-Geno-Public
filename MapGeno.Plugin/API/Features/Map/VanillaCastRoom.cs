using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using UnityEngine;

namespace MapGeno.API.Features.Map
{
    public class VanillaCastRoom
    {
        [JsonProperty(PropertyName = "name")]
        public string Name;
        [JsonProperty(PropertyName = "points")]
        public List<RoomRaycastPoint> Points;
        [JsonProperty(PropertyName = "accuracy")]
        public float Accuracy;

        public VanillaCastRoom(string name, IEnumerable<RoomRaycastPoint> points, float accuracy = 0)
        {
            this.Name = name;
            this.Points = points.GroupBy(e => e.Position).Select(g => g.First()).ToList();
            Accuracy = accuracy;
        }
    }
}
