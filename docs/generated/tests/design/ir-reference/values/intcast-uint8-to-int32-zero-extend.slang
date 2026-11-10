//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `uint8_t -> int32` widening (zero-extend then re-interpret) lowers to a single `intCast(%u8a)` with `Int` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Unsigned-to-signed widening: the doc parenthetically says
// "sign/zero extension chosen by types". This case selects the
// zero-extension branch because the source is unsigned.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint8_t u8a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(u8a);
}

// IR-LABEL: func %main
// IR: intCast(%u8a)
