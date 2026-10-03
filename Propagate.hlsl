
#include "common.hlsl"

static uint g_tileSize = 1u << OUT_MIP;



/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	// 0..g_tileSize-1, 0..g_tileSize-1
	uint2 localPos = DTid % g_tileSize;
	// 0..g_tileSize*g_tileSize-1
	// todo: improve
	uint angleInt = localPos.x + localPos.y * g_tileSize;
	// 0..2*PI
	float angle = angleInt * (PI * 2 / g_tileSize / g_tileSize);
	float2 sc = float2(sin(angle), cos(angle));

	float3 color;

	const float d = g_tileSize * 4;

	float2 uv = (pxPos + d * sc) / /*$(Variable:iResolution)*/;

	color = g_Source.SampleLevel(g_bilinear, uv, 0.0f);
	
	g_Radiance[DTid] = float4(color, 1);
}
