
// shared body of Propagate.hlsl / PropagateMerge.hlsl, included after their ShaderResources

// CASCADE: 0 = finest (1 probe per pixel)
// HAS_UPPER: 1 if g_Upper (cascade CASCADE+1, already merged) is bound, set by the including file
// RC_RESOLUTION, RC_INTERVAL_SCALE: Gigi variables, defined by the including file (Gigi doesn't expand variables in includes)

// probe spacing in pixels, each probe stores T*T pre-averaged directions (4 rays each)
static const uint T = 1u << CASCADE;

// g_Occupancy cell size in pixels, must match Occupancy.hlsl
static const float OCC_CELL = 8.0f;

// front to back from a to b: rgb = gathered radiance, a = transmittance left at b
float4 March(float2 a, float2 b, float2 res)
{
	float3 radiance = 0;
	float trans = 1.0f;

	float len = length(b - a);
	float2 dir = (b - a) / max(len, 1e-6f);

	// todo: distance field
	[loop] for (float t = 0; t < len; )
	{
		float2 pos = a + t * dir;

		// left the screen, nothing more to gather
		if (any(pos < 0) || any(pos >= res))
			break;

		// nothing within OCC_CELL pixels: skip ahead without sampling (-1 for the bilinear footprint)
		if (g_Occupancy[uint2(pos / OCC_CELL)].r == 0)
		{
			t += OCC_CELL - 1.0f;
			continue;
		}

		float4 s = g_Source.SampleLevel(g_bilinear, pos / res, 0.0f);

		radiance += trans * s.rgb * s.a;
		trans *= 1.0f - s.a;

		if (trans < 0.01f)
		{
			trans = 0;
			break;
		}
		t += 1.0f;
	}
	return float4(radiance, trans);
}

[numthreads(8, 8, 1)]
void main(uint2 DTid : SV_DispatchThreadID)
{
	float2 res = RC_RESOLUTION;

	// direction-first layout: each direction is a PxP image of all probes
	uint2 P = uint2(res) / T;
	uint2 dir2D = DTid / P;
	uint2 probe = DTid % P;
	uint dirIndex = dir2D.x + dir2D.y * T;
	float2 origin = (probe + 0.5f) * T;

	// 4^(CASCADE+1)
	float rayCount = 4.0f * T * T;

	// interval [4^(c-1), 4^c) in pixels
	float scale = RC_INTERVAL_SCALE;
#if CASCADE == 0
	float tStart = 0;
#else
	float tStart = scale * float(1u << (2 * (CASCADE - 1)));
#endif
	float tEnd = scale * float(1u << (2 * CASCADE));

	float3 sum = 0;

	for (uint k = 0; k < 4; ++k)
	{
		// ray index in this cascade, its 4 children in the upper cascade are 4j..4j+3
		// which upper texel j already stores pre-averaged
		uint j = dirIndex * 4 + k;
		float angle = (j + 0.5f) * (2 * PI / rayCount);

		float2 dir = float2(cos(angle), sin(angle));

#if HAS_UPPER
		// bilinear fix: march to each of the 4 upper probes' interval start so the intervals
		// connect without overlap (double counted = brighter rings) or gaps (leaks)
		uint T2 = T * 2;
		int2 P2 = int2(P / 2);
		uint2 upDir = uint2(j % T2, j / T2);
		float2 g = origin / T2 - 0.5f;			// our probe in upper probe index space
		int2 base = int2(floor(g));
		float2 f = g - base;

		float4 r = 0;
		[unroll] for (uint c = 0; c < 4; ++c)
		{
			int2 o = int2(c & 1, c >> 1);
			int2 q = clamp(base + o, 0, P2 - 1);
			float w = (o.x ? f.x : 1 - f.x) * (o.y ? f.y : 1 - f.y);
			float2 upOrigin = (q + 0.5f) * T2;

			float4 seg = March(origin + dir * tStart, upOrigin + dir * tEnd, res);
			// upper texel j holds upper rays 4j..4j+3 pre-averaged
			float3 up = g_Upper[uint2(int2(upDir) * P2 + q)].rgb;
			r.rgb += w * (seg.rgb + seg.a * up);
		}
#else
		float4 r = March(origin + dir * tStart, origin + dir * tEnd, res);
#endif

		sum += r.rgb;
	}

	g_Radiance[DTid] = float4(sum * 0.25f, 1);
}
