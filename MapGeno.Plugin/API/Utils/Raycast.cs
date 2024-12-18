using System.Collections.Generic;
using System.Linq;
using Exiled.API.Features;
using UnityEngine;

namespace MapGeno.API.Utils
{
    public class Raycast
    {
        public static List<RaycastHit> RaycastArea(Vector3 position, Vector3 size, float accuracy)
        {
            Log.Info($"Pos: {position}, Size: {size}, Accuracy: {accuracy}");
            var results = new List<RaycastHit>();

            var numRaycastsX = Mathf.CeilToInt(size.x / accuracy);
            var numRaycastsY = Mathf.CeilToInt(size.y / accuracy);
            var numRaycastsZ = Mathf.CeilToInt(size.z / accuracy);

            var stepX = size.x / numRaycastsX;
            var stepY = size.y / numRaycastsY;
            var stepZ = size.z / numRaycastsZ;

            var start = position - size / 2f;

            Vector3[] directions = { Vector3.right, Vector3.left, Vector3.up, Vector3.down, Vector3.forward, Vector3.back };

            foreach (var direction in directions)
            {
                for (var i = 0; i < numRaycastsX; i++)
                {
                    for (var j = 0; j < numRaycastsY; j++)
                    {
                        for (var k = 0; k < numRaycastsZ; k++)
                        {
                            var rayOrigin = start + new Vector3(i * stepX, j * stepY, k * stepZ);
                            var hits = Physics.RaycastAll(rayOrigin, direction, size.magnitude, ~0);
                            results.AddRange(hits);
                        }
                    }
                }
                Log.Debug($"Raycasted direction: {direction}");
            }

            return results;
        }
    }
}
