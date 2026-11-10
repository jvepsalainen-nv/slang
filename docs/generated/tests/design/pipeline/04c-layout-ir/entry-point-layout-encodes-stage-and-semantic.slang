//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#per-entry-point-steps
//META: purpose=The lowered entry-point layout encodes both the pipeline stage and each parameter's system-value semantic.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the entry-point layout records more than binding numbers:
// it carries the stage the entry point was compiled for and the
// system-value semantic of each varying parameter. CHECK looks for a
// `stage(` operand and a `systemValueSemantic("SV_DispatchThreadID"`
// operand in the merged layout block.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CHECK: stage(
// CHECK: systemValueSemantic("SV_DispatchThreadID"
