//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#other-control-flow-opcodes
//META: purpose=A __requirePrelude call lowers to the RequirePrelude instruction carrying the prelude snippet as its single string operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the RequirePrelude row of the backend-hint group. The claim is
// that a call to the core-module intrinsic becomes a dedicated opcode whose
// operand is the prelude text, rather than a call the backend has to
// recognize by name. The CHECK pins the instruction with the exact snippet
// the shader asked for, inside the entry point's block.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    __requirePrelude("// prelude requested by the shader");
    buf[0] = n;
}

// CHECK-LABEL: func %main
// CHECK: RequirePrelude("// prelude requested by the shader")
