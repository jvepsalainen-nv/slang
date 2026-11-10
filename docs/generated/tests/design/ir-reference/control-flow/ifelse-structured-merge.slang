//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#ifelse
//META: purpose=An if/else statement lowers to ifElse(cond, trueBlock, falseBlock, mergeBlock) with the explicit fourth-operand merge block recording the structured join.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A simple `if (a > b) ... else ...` against uniforms produces the
// structured ifElse terminator. The four operands are condition,
// true-arm block, false-arm block, and the explicit merge block.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    if (a > b)
    {
        buf[0] = a;
    }
    else
    {
        buf[0] = b;
    }
}

// CHECK-LABEL: func %main
// CHECK: cmpGT(%a, %b)
// CHECK: ifElse(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}})
