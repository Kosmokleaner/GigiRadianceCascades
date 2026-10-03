
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

	// ambient
	color += 0.2f;

	color += g_Mip1.SampleLevel(g_bilinear, uv, 0.0f).rgb;
	color += g_Mip2.SampleLevel(g_bilinear, uv, 0.0f).rgb;
	color += g_Mip3.SampleLevel(g_bilinear, uv, 0.0f).rgb;
	color += g_Mip4.SampleLevel(g_bilinear, uv, 0.0f).rgb;

	color *= albedo;

//	color = lerp(color, sourceRGBA.rgb, sourceRGBA.a);

	g_Final[DTid] = float4(color, 1);
}
