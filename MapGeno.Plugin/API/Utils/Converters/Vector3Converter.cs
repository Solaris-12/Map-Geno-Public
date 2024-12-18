using System;
using UnityEngine;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace MapGeno.API.Utils.Converters
{
    public class Vector3Converter : JsonConverter<Vector3>
    {
        public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer serializer)
        {
            var jsonObject = new JObject();
            jsonObject.Add("x", value.x);
            jsonObject.Add("y", value.y);
            jsonObject.Add("z", value.z);
            jsonObject.WriteTo(writer);
        }

        public override Vector3 ReadJson(JsonReader reader, Type objectType, Vector3 existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            var jsonObject = JObject.Load(reader);
            var x = (jsonObject.GetValue("x") ?? 0).Value<float>();
            var y = (jsonObject.GetValue("y") ?? 0).Value<float>();
            var z = (jsonObject.GetValue("z") ?? 0).Value<float>();
            return new Vector3(x, y, z);
        }
    }

}
