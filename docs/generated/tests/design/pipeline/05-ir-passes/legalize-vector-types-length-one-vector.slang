//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Boundary: a length-1 vector — the smallest documented vector dimension — is legalized to a plain scalar `int` in the HLSL emit.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Smallest documented vector dimension. `vector<int, 1>` is
// legalized to a scalar `int` on HLSL — the spelling `int1` does
// not appear.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    vector<int, 1> v = vector<int, 1>(int(tid.x));
    buf[0] = v.x;
}

// HLSL: void main
