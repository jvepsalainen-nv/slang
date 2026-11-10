//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=DebugCompilationUnit declares the compilation unit with a single operand referencing a DebugSource.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the compilation-unit record's arity and its target. The CHECK pins
// the closing parenthesis after one operand, so a second operand would fail
// the match, and the captured id is then required to be defined by a
// `DebugSource` -- the link the doc describes.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: = DebugCompilationUnit(%[[SRC:[0-9]+]])
// CHECK: %[[SRC]]{{.*}}= DebugSource(
