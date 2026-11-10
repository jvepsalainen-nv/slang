//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#terminators-switches
//META: purpose=A switch statement lowers to switch(value, breakLabel, defaultLabel, caseVal1, caseBlock1, ...) — scrutinee, break label, default label, then (caseValue, caseBlock) pairs.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A switch over a uniform with three case arms plus default surfaces
// the switch terminator with the documented operand layout. Case
// values appear as inline `<N> : Int` literal operands.

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
    case 3:
        r = 30;
        break;
    default:
        r = 99;
        break;
    }
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK: switch(%sel, %{{[0-9]+}}, %{{[0-9]+}}, 1 : Int, %{{[0-9]+}}, 2 : Int, %{{[0-9]+}}, 3 : Int, %{{[0-9]+}})
