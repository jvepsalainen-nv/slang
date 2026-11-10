//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#emitted-spellings
//META: purpose=A half literal emits with the h suffix and enable f16; is added to the front matter
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<half> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = half(1.5h);
}

// CHECK: enable f16;
// CHECK: array<f16>
// CHECK: = 1.5h;
