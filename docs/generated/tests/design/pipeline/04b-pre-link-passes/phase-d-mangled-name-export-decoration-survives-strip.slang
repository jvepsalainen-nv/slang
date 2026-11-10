//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#module-buildmanglednametoglobalinstmap
//META: purpose=The mangled-name export decorations that the final Phase D index is built from survive the Phase D stripping and dead-code steps.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the precondition for the very last Phase D step. The index that
// the post-link resolver consumes is keyed by mangled name, so the
// `export` decorations must still be on the global instructions once the
// stripping and dead-code steps are done. The CHECKs read the
// post-Phase-D snapshot for the entry point's export decoration sitting
// directly above its function.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK: export("{{.*}}main{{.*}}")
// CHECK-LABEL: func %main
