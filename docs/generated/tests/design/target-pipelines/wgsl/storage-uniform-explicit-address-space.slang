//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#specializeaddressspaceforwgsl
//META: purpose=A loose-uniform global parameter emits with var<uniform> address space and a std140 wrapper struct
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Edge of the address-space axis: a loose uniform parameter goes
// through the GlobalParams_std140 wrapper and emits with the
// var<uniform> address space (distinct from the var<storage,...>
// and var<workgroup> shapes other tests cover).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

uniform float scale;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = scale;
}

// CHECK: var<uniform>
// CHECK-SAME: globalParams_{{[0-9]+}}
// CHECK-SAME: GlobalParams_std140
