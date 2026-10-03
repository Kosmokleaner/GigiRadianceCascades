
/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	int4 mouseInput = int4( /*$(Variable:MouseState)*/);
	int4 mouseInputLastFrame = int4( /*$(Variable:MouseStateLastFrame)*/);

	float2 pxMousePos = mouseInput.xy + 0.5f;

	float brushSize = 10.0f;
	float dist = length(pxPos - pxMousePos);
	float mask = saturate(brushSize - dist);


	float4 rgba = g_Source[DTid].rgba;

	if(mouseInput.z == 1)
		rgba = lerp(rgba, float4(1,1,1,1), mask);
	
	g_Source[DTid] = rgba;
}
