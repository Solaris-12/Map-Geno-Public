using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using Discord;
using Exiled.API.Features;
using MapGeno.API.Features.Objects;
using MapGeno.API.Features.Objects.Serializable;
using UnityEngine;

namespace MapGeno.API.Utils.Converters
{
    internal class SerializedPrimitiveConverter : JsonConverter<SerializedPrimitive>
    {
        public override void WriteJson(JsonWriter writer, SerializedPrimitive value, JsonSerializer serializer)
        {
            var positionToken = JToken.FromObject(value.Position, serializer);

            var jsonObject = new JObject();
            jsonObject.Add("position", positionToken);
            jsonObject.Add("type", (ushort)value.Type);

            if (value is SerializedPrimitiveObject obj)
            {
                var colorToken = JToken.FromObject(obj.Color, serializer);
                var rotationToken = JToken.FromObject(obj.Rotation, serializer);
                var scaleToken = JToken.FromObject(obj.Scale, serializer);

                jsonObject.Add("color", colorToken);
                jsonObject.Add("rotation", rotationToken);
                jsonObject.Add("scale", scaleToken);
            }
            else switch (value.Type)
            {
                case Enums.PrimitiveObjectType.Light when value is SerializedPrimitiveLight light:
                    jsonObject.Add("light_intensity", light.LightIntensity);
                    jsonObject.Add("light_range", light.LightRange);
                    break;
                case Enums.PrimitiveObjectType.Prefab when value is SerializedPrimitivePrefab prefab:
                {
                    var prefabTypeToken = JToken.FromObject(prefab.PrefabType, serializer);
                    var rotationToken = JToken.FromObject(prefab.Rotation, serializer);
                    var scaleToken = JToken.FromObject(prefab.Scale, serializer);

                    jsonObject.Add("prefab_type", prefabTypeToken);
                    jsonObject.Add("rotation", rotationToken);
                    jsonObject.Add("scale", scaleToken);
                    break;
                }
                case Enums.PrimitiveObjectType.ItemSpawn when value is SerializedPrimitiveItemSpawn itemSpawner:
                {
                    var itemTypeToken = JToken.FromObject(itemSpawner.ItemType, serializer);
                    var rotationToken = JToken.FromObject(itemSpawner.Rotation, serializer);
                    var scaleToken = JToken.FromObject(itemSpawner.Scale, serializer);

                    jsonObject.Add("item_type", itemTypeToken);
                    jsonObject.Add("rotation", rotationToken);
                    jsonObject.Add("scale", scaleToken);
                    break;
                }
                case Enums.PrimitiveObjectType.SpawnPoint when value is SerializedPrimitiveSpawnPoint spawnPoint:
                {
                    var roleTypeToken = JToken.FromObject(spawnPoint.RoleType, serializer);
                    var rotationToken = JToken.FromObject(spawnPoint.Rotation, serializer);

                    jsonObject.Add("role_type", roleTypeToken);
                    jsonObject.Add("rotation", rotationToken);
                    break;
                }
                case Enums.PrimitiveObjectType.Door when value is SerializedPrimitiveDoor door:
                {
                    var rotationToken = JToken.FromObject(door.Rotation, serializer);
                    var scaleToken = JToken.FromObject(door.Scale, serializer);
                    var doorTypeToken = JToken.FromObject(door.DoorType, serializer);
                    var lockTypeToken = JToken.FromObject(door.LockType, serializer);
                    var permissionsToken = JToken.FromObject(door.Permissions, serializer);
                    var isOpenToken = JToken.FromObject(door.IsOpen, serializer);
                    var allow106Token = JToken.FromObject(door.Allow106, serializer);
                    
                    jsonObject.Add("rotation", rotationToken);
                    jsonObject.Add("scale", scaleToken);
                    jsonObject.Add("door_type", doorTypeToken);
                    jsonObject.Add("lock_type", lockTypeToken);
                    jsonObject.Add("permissions", permissionsToken);
                    jsonObject.Add("is_open", isOpenToken);
                    jsonObject.Add("allow_106", allow106Token);
                    break;
                }
            }

            jsonObject.WriteTo(writer);
        }

        public override SerializedPrimitive ReadJson(JsonReader reader, Type objectType, SerializedPrimitive existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            var jsonObject = JObject.Load(reader);

            var relativePosition = jsonObject["position"].ToObject<Vector3>(serializer);
            var type = (Enums.PrimitiveObjectType)jsonObject["type"].ToObject<ushort>(serializer);

            SerializedPrimitive primitiveObject;
            switch (type)
            {
                case Enums.PrimitiveObjectType.Cube:
                case Enums.PrimitiveObjectType.Sphere:
                case Enums.PrimitiveObjectType.Capsule:
                case Enums.PrimitiveObjectType.Cylinder:
                case Enums.PrimitiveObjectType.Plane:
                {
                    var color = jsonObject["color"].ToObject<Color>(serializer);
                    var rotation = jsonObject["rotation"].ToObject<Vector3>(serializer);
                    var scale = jsonObject["scale"].ToObject<Vector3>(serializer);
                    primitiveObject = new SerializedPrimitiveObject(type, relativePosition, rotation, scale, color);
                    break;
                }
                case Enums.PrimitiveObjectType.Light:
                {
                    var color = jsonObject["color"].ToObject<Color>(serializer);
                    var lightIntensity = jsonObject["light_intensity"].ToObject<float>(serializer);
                    var lightRange = jsonObject["light_range"].ToObject<float>(serializer);
                    var lightShadowsToken = jsonObject["light_shadows"];
                    var lightShadows = (lightShadowsToken == null || lightShadowsToken.Type == JTokenType.Null || lightShadowsToken.ToObject<bool>(serializer));
                    primitiveObject = new SerializedPrimitiveLight(type, relativePosition, color, lightIntensity, lightRange, lightShadows);
                    break;
                }
                case Enums.PrimitiveObjectType.Prefab:
                {
                    var rotation = jsonObject["rotation"].ToObject<Vector3>(serializer);
                    var scale = jsonObject["scale"].ToObject<Vector3>(serializer);
                    var prefabType = jsonObject["prefab_type"].ToObject<string>(serializer);
                    primitiveObject = new SerializedPrimitivePrefab(type, relativePosition, rotation, scale, prefabType);
                    break;
                }
                case Enums.PrimitiveObjectType.ItemSpawn:
                {
                    var rotation = jsonObject["rotation"].ToObject<Vector3>(serializer);
                    var scale = jsonObject["scale"].ToObject<Vector3>(serializer);
                    var itemType = jsonObject["item_type"].ToObject<string>(serializer);
                    primitiveObject = new SerializedPrimitiveItemSpawn(type, relativePosition, rotation, scale, itemType);
                    break;
                }
                case Enums.PrimitiveObjectType.SpawnPoint:
                {
                    var rotation = jsonObject["rotation"].ToObject<Vector3>(serializer);
                    var roleType = jsonObject["role_type"].ToObject<string>(serializer);
                    primitiveObject = new SerializedPrimitiveSpawnPoint(type, relativePosition, rotation, roleType);
                    break;
                }
                case Enums.PrimitiveObjectType.Door:
                {
                    var rotation = jsonObject["rotation"].ToObject<Vector3>(serializer);
                    var scale = jsonObject["scale"].ToObject<Vector3>(serializer);
                    var doorType = jsonObject["door_type"].ToObject<string>(serializer);
                    var lockType = jsonObject["lock_type"].ToObject<int>(serializer);
                    var permissions = jsonObject["permissions"].ToObject<int>(serializer);
                    var isOpen = jsonObject["is_open"].ToObject<bool>(serializer);
                    var allow106 = jsonObject["allow_106"].ToObject<bool>(serializer);
                    primitiveObject = new SerializedPrimitiveDoor(type, relativePosition, rotation, scale, doorType, isOpen, allow106, lockType, permissions);
                    break;
                }
                case Enums.PrimitiveObjectType.Group:
                    return null; // Ignore
                default:
                    Log.Warn($"No parser for {type} primitive");
                    return null;
            }

            return primitiveObject;
        }
    }
}
