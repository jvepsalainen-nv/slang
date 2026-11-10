//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `double -> int64_t` truncation lowers to a single `castFloatToInt(%da)` with `Int64` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Widest-rank float to widest-rank signed int. Verifies that lowering keeps it
// under the same `castFloatToInt` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform double da;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int64_t(da);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%da)
