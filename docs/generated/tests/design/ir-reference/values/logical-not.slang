//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Prefix `!` on a boolean lowers to the `not` opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that prefix `!` produces the logical `not` opcode, which is
// a different opcode from the bitwise `bitnot` behind `~`. Applying `!`
// to a `uniform bool` keeps the operand non-constant, so CHECK observes
// `not(%c)` rather than a folded literal.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool c;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    bool nc = !c;
    buf[0] = select(nc, 1, 0);
}

// IR-LABEL: func %main
// IR: not(%c)
