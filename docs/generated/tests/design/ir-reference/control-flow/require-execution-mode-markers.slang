//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#other-control-flow-opcodes
//META: purpose=The three operand-less execution-mode markers RequireComputeDerivative, RequireMaximallyReconverges, and RequireQuadDerivatives each lower from their own core-module intrinsic call.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the three no-operand rows of the backend-hint group together,
// since the surface for all of them is the same shape -- an argument-less
// call to a core-module intrinsic -- and a single entry point can carry all
// three. The CHECKs assert each marker appears as its own instruction line
// inside the entry point's block, in call order, which is what shows the
// front end mapped each intrinsic to a distinct opcode rather than folding
// them into a shared decoration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(2, 2, 1)]
void main()
{
    __requireComputeDerivative();
    __requireMaximallyReconverges();
    __requireQuadDerivatives();
    buf[0] = n;
}

// CHECK-LABEL: func %main
// CHECK: RequireComputeDerivative
// CHECK-NEXT: RequireMaximallyReconverges
// CHECK-NEXT: RequireQuadDerivatives
