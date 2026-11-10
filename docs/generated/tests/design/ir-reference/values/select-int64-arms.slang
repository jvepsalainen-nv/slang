//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#select
//META: purpose=Expansion: `select` with widest-rank integer arms lowers to `select(%c, %a, %b)` with `Int64` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `select` opcode is unchanged at the 64-bit
// integer rank.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool c;
uniform int64_t a;
uniform int64_t b;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(c, a, b);
}

// IR-LABEL: func %main
// IR: select(%c, %a, %b)
