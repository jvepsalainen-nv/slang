//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#entry-point-shape
//META: purpose=Under a `metallib_4_0` capability set the compute stage attribute is prefixed with `[[required_threads_per_threadgroup(X, Y, Z)]]` built from the Slang thread-group size.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one condition under which a Slang `[numthreads]` group size
// does reach Metal text. The same kernel that emits a bare `[[kernel]]`
// signature at the default language version gains the required-threads
// prefix once the target capability set implies metallib 4.0, so the CHECK
// pins the three literal group dimensions carried across from the source
// attribute. The double brackets are escaped because FileCheck otherwise
// reads them as a variable reference.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry computeMain -stage compute -capability metallib_4_0

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8, 4, 2)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = tid.x;
}

// CHECK: {{\[\[}}required_threads_per_threadgroup(8, 4, 2){{\]\]}}
// CHECK: kernel{{.*}} void computeMain(
