//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#performmandatoryearlyinlining-and-the-surrounding-loop
//META: purpose=The prelinkIR import of cross-module [unsafeForceInlineEarly] bodies plus the Phase C mandatory-early-inlining loop leaves the core arithmetic operator inlined rather than called.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the cooperation between the pre-link import step and the
// force-inline loop, which is the only user-visible consequence of either.
// `a + b` on plain ints resolves to a core-module operator that is marked
// force-inline-early; because its body was imported and then inlined, the
// snapshot shows the raw `add` opcode at the use site instead of a call to
// the operator function.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK: add(%a, %b)
