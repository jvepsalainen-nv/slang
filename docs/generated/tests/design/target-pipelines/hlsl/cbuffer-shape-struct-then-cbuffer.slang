//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=A cbuffer field group is emitted as a struct declaration followed by a cbuffer block that wraps a field of that struct type on HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The HLSL emitter lifts the cbuffer's fields into a named
// struct (`SLANG_ParameterGroup_<Name>_0`) and then declares
// the `cbuffer` block as a single field of that struct type.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

cbuffer Params {
    float scale;
    int count;
};
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = scale * float(count);
}

// CHECK: struct SLANG_ParameterGroup_Params{{.*}}
// CHECK: float scale_{{[0-9]+}};
// CHECK: int count_{{[0-9]+}};
// CHECK: cbuffer Params_{{[0-9]+}} : register(b{{[0-9]+}})
