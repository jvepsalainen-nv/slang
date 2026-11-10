//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-a-link-and-entry-point-prep
//META: purpose=lowerEnumType replaces enumerator references with the underlying integer literal in WGSL emit
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The enum's underlying integer value is the only thing that
// survives to emit. The enumerator name 'Green' should not appear
// in the output.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

enum Color { Red = 0, Green = 1, Blue = 2 };

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(Color.Green);
}

// CHECK: outBuf_{{[0-9]+}}{{.*}}i32(1)
