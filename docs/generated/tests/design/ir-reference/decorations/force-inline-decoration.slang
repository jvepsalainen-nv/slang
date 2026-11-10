//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=A function decorated with [ForceInline] carries a ForceInline decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `ForceInline` row: nullary decoration produced by the
// `[ForceInline]` attribute. The CHECK sequence pins the decoration, then
// the helper's `nameHint`, then `func %helperInline`, so the decoration is
// shown attached to the user function rather than matched somewhere in the
// core-module preamble.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[ForceInline]
int helperInline(int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helperInline(int(tid.x));
}

// CHECK: [ForceInline]
// CHECK: [nameHint("helperInline")]
// CHECK: func %helperInline
