//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#value-instructions
//META: purpose=A `bit_cast` bit reinterpretation lowers to the `bitCast` conversion opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `bitCast` conversion-opcode example. `bit_cast<uint>(f)`
// reinterprets a non-constant `float` bit-pattern as `uint`, which
// lowers to the `bitCast` opcode (distinct from the value-preserving
// `intCast`/`floatCast`) in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float f;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = bit_cast<uint>(f);
}

// IR-LABEL: func %main
// IR: bitCast(%{{.*}})
