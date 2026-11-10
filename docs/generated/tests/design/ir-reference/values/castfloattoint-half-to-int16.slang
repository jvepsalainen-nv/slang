//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: smallest-rank float to small signed int `half -> int16_t` lowers to `castFloatToInt(%ha)` with `Int16` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Tiny-rank float to small-rank signed int. The doc places it
// under the same `castFloatToInt` opcode as the standard rank
// pair.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half ha;
uniform RWStructuredBuffer<int16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int16_t(ha);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%ha)
