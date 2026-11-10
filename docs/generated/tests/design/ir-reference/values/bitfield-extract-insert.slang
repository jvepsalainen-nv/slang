//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=The `bitfieldExtract(v, off, count)` and `bitfieldInsert(b, ins, off, count)` builtins lower to the IR opcodes of the same names.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Arithmetic and bitwise table lists `bitfieldExtract` and
// `bitfieldInsert` with AST origins "`BitfieldExtract` intrinsic"
// and "`BitfieldInsert` intrinsic". Both opcodes carry their
// offset/count operands inline as `<N> : UInt` payloads.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform uint b;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bitfieldExtract(a, 4, 8);
    buf[1] = bitfieldInsert(a, b, 4, 8);
}

// IR-LABEL: func %main
// IR: bitfieldExtract(%a, 4 : UInt, 8 : UInt)
// IR: bitfieldInsert(%a, %b, 4 : UInt, 8 : UInt)
