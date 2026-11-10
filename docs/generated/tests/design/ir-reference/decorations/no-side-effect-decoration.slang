//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=A function decorated with [__NoSideEffect] carries a noSideEffect decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `noSideEffect` row, the marker that tells later passes a
// callee is free of side effects. The CHECK pins the bare decoration
// followed by the helper's `nameHint` and `func` line so the property is
// observed on the user function that declared it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[__NoSideEffect]
int helperPure(int x) { return x ^ 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helperPure(int(tid.x));
}

// CHECK: [noSideEffect]
// CHECK: [nameHint("helperPure")]
// CHECK: func %helperPure
