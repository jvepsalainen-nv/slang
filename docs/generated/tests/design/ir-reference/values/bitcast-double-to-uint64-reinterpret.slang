//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: reverse 64-bit reinterpret `bit_cast<uint64_t>(double)` lowers to `bitCast(%da)` with `UInt64` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Reverse direction of the 64-bit same-width reinterpret pair.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double da;
uniform RWStructuredBuffer<uint64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bit_cast<uint64_t>(da);
}

// IR-LABEL: func %main
// IR: bitCast(%da)
