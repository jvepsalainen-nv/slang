//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=The int literal -2147483648 emits as i32(-2147483648) at the lower edge of the signed 32-bit range
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower edge of the int32 range; the WGSL emitter writes the
// negative value inside an i32(...) constructor cast.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = -2147483648;
}

// CHECK: i32(-2147483648)
