//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#value-instructions
//META: purpose=An explicit integer-width cast lowers to the `intCast` conversion opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's conversion-opcode row (`bitCast`, `intCast`,
// `floatCast`). A constructor-style `int64_t(a)` on a non-constant
// `int` produces the `intCast` opcode in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int64_t(a);
}

// IR-LABEL: func %main
// IR: intCast(%{{.*}})
