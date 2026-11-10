//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debugline
//META: purpose=Lowering emits separate DebugLine markers for a for statement's condition and its increment, each landing in the block that evaluates it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `for` is not marked as one statement but as its parts, which
// is what lets a debugger stop separately on the test and on the step. Both
// sub-expressions are on the same source line, so the markers can only be told
// apart by their column range -- and they land in different blocks, the
// condition ahead of the `ifElse` that leaves the loop and the increment in the
// continue block. The CHECKs anchor at `func %main` so no core-module function
// can satisfy them, then require the two column ranges in that order.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g1

uniform RWStructuredBuffer<float> gOut;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float acc = 0.0;
    for (uint i = 0; i < tid.x; ++i)
    {
        acc += float(i);
    }
    gOut[0] = acc;
}

// CHECK: {{^}}func %main {{.*}}Func(Void,
// The condition `i < tid.x` starts at column 24 of the `for` line; the marker
// precedes the branch that decides whether to leave the loop.
// CHECK: DebugLine(%{{[0-9]+}}, 24 : UInt, 24 : UInt, 24 : UInt, 25 : UInt)
// CHECK: ifElse(
// The increment `++i` starts at column 33 of the same line and is marked in
// the loop's continue block, after the body.
// CHECK: DebugLine(%{{[0-9]+}}, 24 : UInt, 24 : UInt, 33 : UInt, 34 : UInt)
