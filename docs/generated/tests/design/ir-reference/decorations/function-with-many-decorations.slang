//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=Stress - a single function carrying many compatible inlining-and-optimization decorations produces every corresponding decoration in the dump, with no interference between them.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the inlining/optimization decorations are independent
// markers that accumulate on one inst. Four attributes are stacked on a
// single helper and the CHECK-DAG lines assert `ForceInline`,
// `noSideEffect`, `readNone` and `unsafeForceInlineEarly` all appear
// alongside the helper's `nameHint`, which anchors the match at user code.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[ForceInline]
[__NoSideEffect]
[__readNone]
[__unsafeForceInlineEarly]
int superHelper(int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = superHelper(int(tid.x));
}

// CHECK-DAG: [ForceInline]
// CHECK-DAG: [noSideEffect]
// CHECK-DAG: [readNone]
// CHECK-DAG: [unsafeForceInlineEarly]
// CHECK-DAG: [nameHint("superHelper")]
