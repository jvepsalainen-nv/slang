//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#inlining-and-optimization
//META: purpose=Boundary - a function carrying [__readNone] surfaces a bare readNone decoration distinct from noSideEffect and the other inlining-and-optimization opcodes.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `readNone` is its own marker rather than a synonym of
// `noSideEffect`: the same helper shape as the `noSideEffect` test is used
// and only the attribute changes, so the CHECK on `[readNone]` distinguishes
// the two rows. The user-visible spelling is `[__readNone]`; the doc's
// `[__readNone]` naming is what this test exercises.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[__readNone]
int pureFn(int x) { return x * 2; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = pureFn(int(tid.x));
}

// CHECK: [readNone]
// CHECK: [nameHint("pureFn")]
// CHECK: func %pureFn
