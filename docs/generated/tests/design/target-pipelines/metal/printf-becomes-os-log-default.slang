//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#phase-d-metal-emit-and-downstream-tools
//META: purpose=`printf` becomes MSL shader logging: the emitter writes `os_log_default.log(...)` and pulls in `<metal_logging>` on demand.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Metal rendering of `printf`, which has no MSL equivalent
// and used to be dropped entirely. The logging header is included on
// demand rather than in the fixed front matter because it only exists from
// MSL 3.2 onward, so its presence is itself evidence the on-demand prelude
// path ran. CHECK asserts the `<metal_logging>` include appears after the
// standard prelude and that the call site emits `os_log_default.log(`.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("hi %d", int(tid.x));
    outBuf[tid.x] = 1.0f;
}

// CHECK: using namespace metal;
// CHECK: #include <metal_logging>
// CHECK: os_log_default.log(
