//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#terminators-switches
//META: purpose=Boundary: the source-text position of `default:` (before or after the case-arms) does not affect the switch terminator's operand layout — the default label is still the third operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Writing `default:` ahead of the case-arms is legal Slang. The
// lowering still emits the switch with `value, breakLabel, defaultLabel`
// as the three leading operands and the `(caseVal, caseBlock)` pairs
// after them.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int r = 0;
    switch (sel)
    {
    default:
        r = 0;
        break;
    case 1:
        r = 10;
        break;
    case 2:
        r = 20;
        break;
    }
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK: switch(%sel, %{{[0-9]+}}, %{{[0-9]+}}, 1 : Int, %{{[0-9]+}}, 2 : Int, %{{[0-9]+}})
