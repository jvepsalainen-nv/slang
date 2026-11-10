//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=The `<<` operator lowers to `shl` and `>>` lowers to `shr`; the doc notes the arithmetic-vs-logical choice is keyed by operand signedness.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two shift operators, on signed and unsigned integers, both
// surface the `shl` / `shr` opcodes the doc lists in the Arithmetic
// and bitwise table.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform uint ua;
uniform int amt;
uniform RWStructuredBuffer<int> buf;
uniform RWStructuredBuffer<uint> ubuf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a << amt;
    buf[1] = a >> amt;
    ubuf[0] = ua << amt;
    ubuf[1] = ua >> amt;
}

// IR-LABEL: func %main
// IR: shl(%a, %amt)
// IR: shr(%a, %amt)
// IR: shl(%ua, %amt)
// IR: shr(%ua, %amt)
