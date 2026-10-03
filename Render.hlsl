
/*$(ShaderResources)*/

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
    float2 pxPos = DTid + 0.5f;

	int4 mouseInput = int4( /*$(Variable:MouseState)*/);
	int4 mouseInputLastFrame = int4( /*$(Variable:MouseStateLastFrame)*/);

	float2 pxMousePos = mouseInput.xy + 0.5f;

	float dist = length(pxPos - pxMousePos);
	float mask = saturate(3.0f - dist);


	float3 color = Final[DTid].rgb;

	if(mouseInput.z == 1)
		color = lerp(color, float3(1,1,1), mask);
	
	Final[DTid] = float4(color,1);
}
