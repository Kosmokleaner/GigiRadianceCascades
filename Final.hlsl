
#include "common.hlsl"

/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
	const float3 albedo = 0.5f;

	float2 pxPos = DTid + 0.5f;

	float2 uv = pxPos / /*$(Variable:iResolution)*/;

	float4 sourceRGBA = g_Source[DTid];

	float3 color = 0;

	// ambient, hides leaks, keep 0 while debugging
//	color += 0.2f;

	// cascade 0 has 1 probe per pixel, texel = average of its 4 rays = fluence
	color += g_Cascade0[DTid].rgb;

	color *= albedo;

//	color = lerp(color, sourceRGBA.rgb, sourceRGBA.a);

	g_Final[DTid] = float4(color, 1);
}
