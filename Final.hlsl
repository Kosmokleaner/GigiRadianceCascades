
#include "common.hlsl"

/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	float4 sourceRGBA = g_Source[DTid];

	float3 color = g_Mip3.SampleLevel(g_bilinear, pxPos / /*$(Variable:iResolution)*/, 0.0f).rgb;

	color = lerp(color, sourceRGBA.rgb, sourceRGBA.a);

	g_Final[DTid] = float4(color, 1);
}
