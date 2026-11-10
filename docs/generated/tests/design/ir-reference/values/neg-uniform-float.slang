//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: prefix `-` on a `uniform float` lowers to `neg(%fa)` — the float-typed sibling of the integer `neg` exercised in the smoke test.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that prefix `-` produces the same single `neg` opcode
// regardless of operand type. The smoke covers `int`; this boundary probe
// covers `float`. (Float negation handles ±0.0, ±inf, and NaN per
// IEEE-754; the IR opcode shape is the same.)

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = -fa;
}

// IR-LABEL: func %main
// IR: neg(%fa)
