//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#entry-point-and-parameter-handling
//META: purpose=Expansion: lower-out-parameters preserves the `out` keyword on multiple parameters (two `out` parameters in one helper) on HLSL — many-args axis to the existing single-out case.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Multi-out-parameter axis on lower-out-parameters. Two `out`
// parameters on the same helper survive on HLSL.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

void splitAndDouble(int n, out int evenPart, out int oddPart)
{
    evenPart = n & ~1;
    oddPart  = n & 1;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int e, o;
    splitAndDouble(a + int(tid.x), e, o);
    buf[0] = e * 10 + o;
}

// HLSL: out int{{.*}}, out int
