
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

	float4 rgba = g_Source[DTid].rgba;

	if(mouseInput.z == 1)
	{
		float3 color = 0;

		uint iColor = /*$(Variable:iColor)*/;

		if(iColor == 1)
			color = float3(0.9f,0.7f, 0.5f) * 10;
		else if (iColor == 2)
			color = float3(1,0,0);
		else if (iColor == 3)
			color = float3(0, 1, 0);
		else if (iColor == 4)
			color = float3(0, 0, 1);

		rgba = lerp(rgba, float4(color,1), mask);
	}

	if(/*$(Variable:Clear)*/)
		rgba = 0;
	
	g_Source[DTid] = rgba;
}
