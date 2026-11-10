//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#block-and-param
//META: purpose=A block parameter encodes Slang IR's replacement for an SSA phi node — the receiving block declares the param, predecessors supply the matching argument on their unconditionalBranch.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The post-switch merge block becomes the home of an SSA phi: each
// arm writes a different value to a local, and the merge block
// declares a `param %r : Int` that the predecessors' branches
// supply as their argument.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int r = 0;
    switch (sel)
    {
    case 1:
        r = 10;
        break;
    case 2:
        r = 20;
        break;
    default:
        r = 99;
        break;
    }
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK: switch(%sel
// CHECK: param %r	: Int
