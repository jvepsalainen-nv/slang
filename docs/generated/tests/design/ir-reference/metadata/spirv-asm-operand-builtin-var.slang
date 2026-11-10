//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#spirvasmoperand
//META: purpose=A builtin(...) token in an inline-asm instruction becomes a SPIRVAsmOperandBuiltinVar operand carrying the built-in kind.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the built-in variable reference is carried as a typed operand with
// its kind as an operand of its own. The block loads a subgroup built-in; the
// CHECK requires the operand to print by its opcode mnemonic with a single
// integer operand, which is what lets a later pass materialise the actual
// built-in variable.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -capability spvGroupNonUniform

uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = spirv_asm
    {
        result:$$uint = OpLoad builtin(SubgroupSize:uint)
    };
}

// CHECK: SPIRVAsmInst({{[0-9]+}} : UInt, UInt, result, SPIRVAsmOperandBuiltinVar({{[0-9]+}} : Int))
