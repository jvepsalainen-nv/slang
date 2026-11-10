//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=A function decorated with [noinline] carries a noInline decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `noInline` row: nullary decoration produced by the
// `[noinline]` attribute. The CHECK sequence pins the decoration, the
// helper's `nameHint`, and the `func` line, anchoring the match at user
// code so a core-module declaration cannot satisfy it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[noinline]
int helperNoInline(int x) { return x * 2; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helperNoInline(int(tid.x));
}

// CHECK: [noInline]
// CHECK: [nameHint("helperNoInline")]
// CHECK: func %helperNoInline
