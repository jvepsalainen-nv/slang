//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#specializeaddressspaceforwgsl
//META: purpose=Module-scope static variables become var<private> with the initializer fired inside main
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A module-scope 'static int g = 7' becomes a var<private> WGSL
// global; its initializer is moved into the entry-point body by
// moveGlobalVarInitializationToEntryPoints.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

static int g_counter = 7;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = g_counter;
}

// CHECK: var<private>
// CHECK-SAME: g_counter_{{[0-9]+}}
// CHECK: fn main
// CHECK: g_counter_{{[0-9]+}} = i32(7)
