
#include "common.hlsl"

/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	float4 sourceRGBA = g_Source[DTid];

	float3 sum = 0;

	[unroll] for(uint y = 0; y < g_tileSize; ++y)
	[unroll] for(uint x = 0; x < g_tileSize; ++x)
	{
		// compiler should make this a 
		uint2 tileStart = DTid / g_tileSize * g_tileSize;
		uint2 tilePos = tileStart + uint2(x, y);

		sum += g_Radiance[tilePos].rgb;
	}

	float3 color = sum / (g_tileSize * g_tileSize);
	
	color = lerp(color, sourceRGBA.rgb, sourceRGBA.a);

	g_Final[DTid] = float4(color, 1);
}
