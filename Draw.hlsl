
/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	int4 mouseInput = int4( /*$(Variable:MouseState)*/);
	int4 mouseInputLastFrame = int4( /*$(Variable:MouseStateLastFrame)*/);

	float2 pxMousePos = mouseInput.xy + 0.5f;

	float brushSize = /*$(Variable:iBrushSize)*/;
	float dist = length(pxPos - pxMousePos);
	float mask = saturate(brushSize - dist);

	float4 dstColor = g_Source[DTid].rgba;

	if(mouseInput.z == 1)
	{
		float4 srcColor = 0;

		uint iColor = /*$(Variable:iColor)*/;

		if (iColor == 0)
			srcColor = float4(0, 0, 0, 1);
		else if(iColor == 1)
			srcColor = float4(float3(0.9f, 0.7f, 0.5f) * 10, 1);
		else if (iColor == 2)
			srcColor = float4(5, 0, 0, 1);
		else if (iColor == 3)
			srcColor = float4(0, 5, 0, 1);
		else if (iColor == 4)
			srcColor = float4(0, 0, 5, 1);

		dstColor = lerp(dstColor, srcColor, mask);
	}

	if(/*$(Variable:Clear)*/)
		dstColor = 0;
	
	g_Source[DTid] = dstColor;
}
