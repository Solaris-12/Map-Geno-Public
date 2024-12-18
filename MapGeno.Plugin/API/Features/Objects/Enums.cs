using System;
using MapGeno.API.Enums;
using UnityEngine;

namespace MapGeno.API.Features.Objects
{
    public class EnumsUtils
    {
        public static PrimitiveType PrimitiveObjectType_TO_PrimitiveType(PrimitiveObjectType input)
        {
            switch (input)
            {
                case PrimitiveObjectType.Cube:
                    return PrimitiveType.Cube;
                case PrimitiveObjectType.Sphere:
                    return PrimitiveType.Sphere;
                case PrimitiveObjectType.Capsule:
                    return PrimitiveType.Capsule;
                case PrimitiveObjectType.Cylinder:
                    return PrimitiveType.Cylinder;
                case PrimitiveObjectType.Plane:
                    return PrimitiveType.Plane;
                default:
                    throw new ArgumentOutOfRangeException(nameof(input), input, null);
            }
        }
        public static string FacilityDoorTypeToPrefabs(FacilityDoorType type)
        {
            switch (type)
            {
                case FacilityDoorType.HeavyContainmentDoor:
                    return "HCZ";
                case FacilityDoorType.LightContainmentDoor:
                    return "LCZ";
                case FacilityDoorType.EntranceContainmentDoor:
                    return "EZ";
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), type, null);
            }
        }
    }
}
