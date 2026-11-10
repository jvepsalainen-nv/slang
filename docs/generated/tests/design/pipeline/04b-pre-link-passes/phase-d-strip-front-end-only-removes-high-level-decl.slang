//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#stripfrontendonlyinstructions
//META: purpose=Phase D's stripFrontEndOnlyInstructions (D10) always removes the front-end-only IRHighLevelDeclDecoration before the module is handed on for code generation.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the unconditional half of the stripping list. The mandatory
// passes use the high-level-decl decoration to point diagnostics back at
// AST-level code, but it must not reach code generation. The module
// declares an ordinary struct and entry point, and the CHECK-NOT asserts
// the decoration's printed form is absent from the post-Phase-D snapshot.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct Helper { int value; };

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Helper h = { 42 };
    buf[0] = h.value;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-NOT: HighLevelDecl
