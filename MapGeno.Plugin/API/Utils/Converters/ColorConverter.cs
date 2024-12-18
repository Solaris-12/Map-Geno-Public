using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace MapGeno.API.Utils.Converters
{
    internal class ColorConverter : JsonConverter<Color>
    {
        public override void WriteJson(JsonWriter writer, Color value, JsonSerializer serializer)
        {
            var jsonObject = new JObject();
            jsonObject.Add("r", value.r);
            jsonObject.Add("g", value.g);
            jsonObject.Add("b", value.b);
            jsonObject.Add("a", value.a);
            jsonObject.WriteTo(writer);
        }

        public override Color ReadJson(JsonReader reader, Type objectType, Color existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            var jsonObject = JObject.Load(reader);
            var r = (jsonObject.GetValue("r") ?? 0).Value<float>();
            var g = (jsonObject.GetValue("g") ?? 0).Value<float>();
            var b = (jsonObject.GetValue("b") ?? 0).Value<float>();
            var a = (jsonObject.GetValue("a") ?? 1).Value<float>();
            return new Color(r, g, b, a);
        }
    }
}
