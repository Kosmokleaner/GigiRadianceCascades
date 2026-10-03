
/*$(ShaderResources)*/

static float PI = 3.14159265f;

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

//	float4 sourceRGBA = Source[DTid];

	uint tileSize = 4;

	// 0..tileSize-1, 0..tileSize-1
	uint2 localPos = DTid % tileSize;
	// 0..tileSize*tileSize-1
	uint angleInt = localPos.x + localPos.y * tileSize;
	// 0..2*PI
	float angle = angleInt * (PI * 2 / tileSize / tileSize);
	float2 sc = float2(sin(angle), cos(angle));

	float3 color;

	const float d = 24.0f;

	float2 uv = (pxPos + d * sc) / /*$(Variable:iResolution)*/;

	color = g_Source.SampleLevel(g_bilinear, uv, 0.0f);
	
	g_Radiance[DTid] = float4(color, 1);
}
