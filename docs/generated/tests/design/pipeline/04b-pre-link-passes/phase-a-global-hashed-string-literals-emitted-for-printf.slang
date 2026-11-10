//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#phase-a-ast-walk-and-ir-emission
//META: purpose=Phase A emits the single kIROp_GlobalHashedStringLiterals aggregate (A8) holding every hashed string literal observed during the declaration walk.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that when the module contains a hashed string literal, Phase A
// closes the declaration walk by emitting one module-scope aggregate that
// collects them. `printf` routes its format string through that table, so
// the CHECK looks for `global_hashed_string_literals` carrying the literal
// text in the post-Phase-D snapshot.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    printf("hello!\n");
    buf[0] = 1;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK: global_hashed_string_literals("hello!\n")
