//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#select
//META: purpose=Expansion: `select(c, vec3, vec3)` with vector operands lowers to a single `select(%c, %a, %b)` with `Vec(Float, 3)` result — verifies the opcode handles aggregate operand pairs.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `select` allows any matching operand
// type pair. Vector operands surface the same opcode shape as
// scalar operands.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool c;
uniform float3 a;
uniform float3 b;
uniform RWStructuredBuffer<float3> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(c, a, b);
}

// IR-LABEL: func %main
// IR: select(%c, %a, %b)
