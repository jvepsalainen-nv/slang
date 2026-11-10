//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#per-global-parameter-steps
//META: purpose=The per-global-parameter loop runs once per field of the global struct layout, so two distinct global parameters produce two distinct structFieldLayout entries.
//META: intent=boundary
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the loop nature of the per-global-parameter step by moving from
// one global to two. CHECK matches two separate `structFieldLayout(%bufX`
// entries, so the layout module recorded a field per global rather than
// collapsing them; a single-global test cannot distinguish "loop" from
// "one-shot".

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> bufA;
uniform RWStructuredBuffer<float> bufB;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bufA[0] = int(tid.x);
    bufB[0] = float(tid.y);
}

// CHECK-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CHECK: structFieldLayout(%buf{{[A-Z]}}
// CHECK: structFieldLayout(%buf{{[A-Z]}}
