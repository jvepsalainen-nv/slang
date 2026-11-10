//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#discard
//META: purpose=`discard` is not a terminator: it sits as an ordinary instruction inside a block, and the block's real terminator (unconditionalBranch to the post-if merge) follows.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A pixel-shader discard inside an if-arm appears in the IR dump as
// a `discard` instruction followed by an `unconditionalBranch` —
// the branch, not the discard, is the block's terminator.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage fragment

uniform float threshold;

float4 main(float4 pos : SV_Position) : SV_Target
{
    if (pos.x < threshold)
        discard;
    return float4(1, 0, 0, 1);
}

// CHECK-LABEL: func %main
// CHECK: discard
// CHECK-NEXT: unconditionalBranch(%{{[0-9]+}})
