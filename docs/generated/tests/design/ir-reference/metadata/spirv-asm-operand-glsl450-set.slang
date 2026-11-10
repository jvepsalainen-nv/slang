//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#spirvasmoperand
//META: purpose=The glsl450 token in an inline-asm instruction becomes a dedicated operand instruction referencing the GLSL.std.450 instruction set.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the extended-instruction-set reference is its own typed
// operand kind and not a literal. The CHECK requires the operand list of the
// `OpExtInst` to contain the set operand printed by its own opcode mnemonic,
// followed by the enumerator selecting the function within that set.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

float f(float x)
{
    return spirv_asm
    {
        result:$$float = OpExtInst glsl450 Sqrt $x
    };
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = f(float(tid.x));
}

// CHECK: SPIRVAsmInst({{[0-9]+}} : UInt, Float, result, SPIRVAsmOperandGLSL450Set, {{[0-9]+}} : UInt
