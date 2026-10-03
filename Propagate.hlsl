
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
	// 0..2*PI + PI/4
	float angle = angleInt * (PI * 2 / g_tileSize / g_tileSize) + PI / 4;
	float2 sc = float2(sin(angle), cos(angle));

	float3 color = 0;

	const float d = 1;
	const uint scale = 4;

	float transmission = 1.0f;
	[loop] for(uint step = g_tileSize * scale; step < g_tileSize * scale * 2; ++step)
	{
		float2 uv = (pxPos + (step * d) * sc) / /*$(Variable:iResolution)*/;

		float4 source = g_Source.SampleLevel(g_bilinear, uv, 0.0f);

		color *= (1.0f - source.a);
		color += source.rgb * 4.0f / step;
	}
	color /= scale;

	g_Radiance[DTid] = float4(color, 1);
}
