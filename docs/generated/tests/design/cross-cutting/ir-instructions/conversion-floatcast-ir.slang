//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#value-instructions
//META: purpose=An explicit float-width cast lowers to the `floatCast` conversion opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `floatCast` conversion-opcode example. A
// constructor-style `float(d)` narrowing a non-constant `double`
// produces `floatCast` in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double d;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = float(d);
}

// IR-LABEL: func %main
// IR: floatCast(%{{.*}})
