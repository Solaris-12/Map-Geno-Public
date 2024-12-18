using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapGeno.API.Features.Objects;
using PlayerRoles;
using UnityEngine;

namespace MapGeno.API
{

    public class PrimitiveBuilder
    {
        private Enums.PrimitiveObjectType _type;
        private string _prefabType = string.Empty;
        private string _roleType = string.Empty;
        private Primitive _instance = null;

        public PrimitiveBuilder(Enums.PrimitiveObjectType type)
        {
            _type = type;

            var primitiveType = Primitive.FromObjectType(type);
            _instance = (Primitive)Activator.CreateInstance(primitiveType);
        }

        public PrimitiveBuilder SetMotionSmoothing(byte smth)
        {
            _instance.MotionSmoothing = smth;
            return this;
        }

        public PrimitiveBuilder SetPosition(Vector3 pos)
        {
            this.SetPosition(pos.x, pos.y, pos.z);
            return this;
        }
        public PrimitiveBuilder SetPosition(float x, float y, float z)
        {
            _instance.RelativePosition = new Vector3(x, y, z);
            return this;
        }

        public PrimitiveBuilder SetRotation(Vector3 rot)
        {
            SetRotation(rot.x, rot.y, rot.z);
            return this;
        }

        public PrimitiveBuilder SetRotation(float x, float y, float z)
        {
            switch (_type)
            {
                case Enums.PrimitiveObjectType.Cube:
                case Enums.PrimitiveObjectType.Sphere:
                case Enums.PrimitiveObjectType.Capsule:
                case Enums.PrimitiveObjectType.Cylinder:
                case Enums.PrimitiveObjectType.Plane:
                    if (_instance is PrimitiveObject primitiveObject) primitiveObject.Rotation = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.Prefab:
                    if (_instance is PrimitivePrefab primitivePrefab) primitivePrefab.Rotation = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.ItemSpawn:
                    if (_instance is PrimitiveItemSpawner primitiveItemSpawn) primitiveItemSpawn.Rotation = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.SpawnPoint:
                    if (_instance is PrimitiveSpawnPoint primitiveSpawnPoint) primitiveSpawnPoint.Rotation = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.Light:
                default:
                    throw new OperationCanceledException($"Cannot set rotation on object that does not have rotation! {_type}");
            }
            return this;
        }

        public PrimitiveBuilder SetScale(Vector3 scl)
        {
            SetScale(scl.x, scl.y, scl.z);
            return this;
        }

        public PrimitiveBuilder SetScale(float x, float y, float z)
        {
            switch (_type)
            {
                case Enums.PrimitiveObjectType.Cube:
                case Enums.PrimitiveObjectType.Sphere:
                case Enums.PrimitiveObjectType.Capsule:
                case Enums.PrimitiveObjectType.Cylinder:
                case Enums.PrimitiveObjectType.Plane:
                    if (_instance is PrimitiveObject primitiveObject) primitiveObject.Scale = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.Prefab:
                    if (_instance is PrimitivePrefab primitivePrefab) primitivePrefab.Scale = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.ItemSpawn:
                    if (_instance is PrimitiveItemSpawner primitiveItemSpawn) primitiveItemSpawn.Scale = new Vector3(x, y, z);
                    break;
                case Enums.PrimitiveObjectType.SpawnPoint:
                case Enums.PrimitiveObjectType.Light:
                default:
                    throw new OperationCanceledException($"Cannot set scale on object that does not have scale! {_type}");
            }
            return this;
        }

        public PrimitiveBuilder SetColor(Color color)
        {
            SetColor(color.r, color.g, color.b, color.a);
            return this;
        }

        public PrimitiveBuilder SetColor(float r, float g, float b, float a)
        {
            switch (_type)
            {
                case Enums.PrimitiveObjectType.Cube:
                case Enums.PrimitiveObjectType.Sphere:
                case Enums.PrimitiveObjectType.Capsule:
                case Enums.PrimitiveObjectType.Cylinder:
                case Enums.PrimitiveObjectType.Plane:
                    if (_instance is PrimitiveObject primitiveObject) primitiveObject.Color = new Color(r, g, b, a);
                    break;
                case Enums.PrimitiveObjectType.Light:
                    if (_instance is PrimitiveLight primitiveLight) primitiveLight.LightColor = new Color(r, g, b, a);
                    break;
                case Enums.PrimitiveObjectType.Prefab:
                case Enums.PrimitiveObjectType.ItemSpawn:
                case Enums.PrimitiveObjectType.SpawnPoint:
                default:
                    throw new OperationCanceledException($"Cannot set color on object that does not have color! {_type}");
            }
            return this;
        }

        public PrimitiveBuilder SetLightIntensity(float li)
        {
            if (_type != Enums.PrimitiveObjectType.Light)
                throw new OperationCanceledException($"Cannot set light intensity on object that does not have light intensity! {_type}");
            if (_instance is PrimitiveLight primitiveLight) primitiveLight.LightIntensity = li;
            return this;
        }

        public PrimitiveBuilder SetLightRange(float lr)
        {
            if (_type != Enums.PrimitiveObjectType.Light)
                throw new OperationCanceledException($"Cannot set light range on object that does not have light range! {_type}");
            if (_instance is PrimitiveLight primitiveLight) primitiveLight.LightRange = lr;
            return this;
        }

        public PrimitiveBuilder SetPrefabType(string prefab_type)
        {
            if (_type != Enums.PrimitiveObjectType.Prefab)
                throw new OperationCanceledException($"Cannot set scale on prefab_type that does not have prefab_type! {_type}");
            if (_instance is PrimitivePrefab primitivePrefab) primitivePrefab.PrefabType = prefab_type;
            return this;
        }

        public PrimitiveBuilder SetRoleType(RoleTypeId role_type)
        {
            if (_type != Enums.PrimitiveObjectType.Prefab)
                throw new OperationCanceledException($"Cannot set scale on role_type that does not have role_type! {_type}");
            if (_instance is PrimitiveSpawnPoint primitiveSpawnPoint) primitiveSpawnPoint.RoleType = role_type;
            return this;
        }

        public Primitive Build()
        {
            return _instance;
        }
    }
}
