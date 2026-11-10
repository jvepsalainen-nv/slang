//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#per-global-parameter-steps
//META: purpose=Recording each stub global in the global type-layout builder yields one structFieldLayout entry naming that stub variable and its lowered varLayout.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fourth per-global-parameter step: each stub global is fed
// into the module-level struct-type-layout builder. CHECK asserts a
// `structFieldLayout(%buf, %N)` entry exists, which names the stub global
// itself as the field key and its lowered varLayout as the value - the
// pairing that step produces.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CHECK: structFieldLayout(%buf, %{{[0-9]+}})
