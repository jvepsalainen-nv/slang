//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[ForceInline]` on a small helper inlines it into the caller; the helper's name no longer appears in emitted HLSL.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `[ForceInline]` causes Slang itself to inline the callee, so no
// call survives to the back end. CHECK asserts the entry point is emitted and
// CHECK-NOT asserts no call to `helper(` remains -- its body having been spliced
// into the call site.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[ForceInline]
int helper(int x)
{
    return x * 2 + 1;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = helper(int(tid.x));
}

//CHECK: void main
//CHECK-NOT: helper(
