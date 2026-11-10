//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=ConstantBuffer<T> emits as a std140-shaped struct with @align field annotations bound as var<uniform>
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A ConstantBuffer<S> uses WGSL's uniform address space; the
// struct fields carry explicit @align(N) annotations matching the
// std140 layout.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

struct CB { float a; float b; float c; };
ConstantBuffer<CB> cb;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = cb.a + cb.b + cb.c;
}

// CHECK: struct CB_std140
// CHECK: @align(
// CHECK: var<uniform>
// CHECK-SAME: cb_{{[0-9]+}}
