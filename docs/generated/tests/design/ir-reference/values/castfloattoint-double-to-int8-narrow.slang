//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `double -> int8_t` truncation lowers to a single `castFloatToInt(%da)` with `Int8` result — combines precision loss and rank narrowing in one opcode.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Doc places this under one opcode regardless of how small the
// destination integer rank is.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double da;
uniform RWStructuredBuffer<int8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int8_t(da);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%da)
