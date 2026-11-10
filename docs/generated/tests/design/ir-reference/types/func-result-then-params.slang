//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#func
//META: purpose=The Func type opcode places the result type first, then parameter types in declaration order.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Func type opcode places the result type first, then parameter
// types in declaration order. The result type is the leading operand;
// the remaining operands are parameter types in declaration order." A
// helper `int helper(int v, float f)` surfaces as `Func(Int, Int,
// Float)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform float b;
uniform RWStructuredBuffer<int> buf;

int helper(int v, float f) { return v + int(f); }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = helper(a, b);
}

// IR-LABEL: func %helper
// IR-SAME: Func(Int, Int, Float)
