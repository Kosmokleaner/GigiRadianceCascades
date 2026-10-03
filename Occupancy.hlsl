
// 1/8 res: 1 if anything with alpha is within OCC_CELL pixels of the cell, so marching can skip empty cells
// (see PropagateCommon.hlsl)

/*$(ShaderResources)*/

static const int OCC_CELL = 8;

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
	int2 size;
	g_Source.GetDimensions(size.x, size.y);

	int2 base = int2(DTid) * OCC_CELL - OCC_CELL;

	float occupied = 0;
	[loop] for (int y = 0; y < OCC_CELL * 3; ++y)
	[loop] for (int x = 0; x < OCC_CELL * 3; ++x)
	{
		int2 p = base + int2(x, y);
		if (all(p >= 0) && all(p < size) && g_Source[p].a > 0.001f)
			occupied = 1;
	}

	g_Occupancy[DTid] = float4(occupied, 0, 0, 0);
}
