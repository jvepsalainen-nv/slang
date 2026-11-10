//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#value-instructions
//META: purpose=An equality comparison lowers to the `cmpEQ` comparison opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's comparison-opcode row via the `cmpEQ` head-of-list
// example: `a == b` on non-constant `uniform` operands lowers to `cmpEQ`
// in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = (a == b) ? 1 : 0;
}

// IR-LABEL: func %main
// IR: cmpEQ(%{{.*}}, %{{.*}})
