//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#swizzle-swizzleset-swizzledstore
//META: purpose=Boundary: M=4 swizzle from an N=2 source (`vec2.xxxy`) lowers to `swizzle(%v, 0, 0, 0, 1)` — M > N, mixed-repeat indices.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that lowering allows M > N when components are repeated. This
// boundary probe takes M=4 from N=2 with two distinct indices
// (one repeated three times), demonstrating the cross-axis
// upsample case.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float2 v;
uniform RWStructuredBuffer<float4> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.xxxy;
}

// IR-LABEL: func %main
// IR: swizzle(%v, 0 : Int, 0 : Int, 0 : Int, 1 : Int)
