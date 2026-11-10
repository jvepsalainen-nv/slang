//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#builtin-operators-bypass-call-lowering
//META: purpose=A builtin `a % b` on integer operands lowers to an `irem` IR opcode — the doc says `%` picks `IRIRem` for non-floating-point operands.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the element-type selection for `%`: non-floating-point
// operands pick the integer-remainder opcode. The dump opcode is
// `irem` (integer remainder) rather than `mod` — the IR-side
// spelling of `IRIRem`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a % b;
}

// CHECK-LABEL: func %main
// CHECK: irem(%{{.*}}, %{{.*}})
