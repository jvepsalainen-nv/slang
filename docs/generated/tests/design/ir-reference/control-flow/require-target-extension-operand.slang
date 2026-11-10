//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#other-control-flow-opcodes
//META: purpose=A __requireTargetExtension call lowers to the RequireTargetExtension instruction carrying the extension name as its operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the RequireTargetExtension row: the intrinsic call becomes its
// own opcode carrying the named extension, which is how the GLSL backend
// later learns to emit the matching `#extension` line. The CHECK pins the
// instruction and its string operand inside the entry point's block.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    __requireTargetExtension("GL_EXT_shader_atomic_int64");
    buf[0] = n;
}

// CHECK-LABEL: func %main
// CHECK: RequireTargetExtension("GL_EXT_shader_atomic_int64")
