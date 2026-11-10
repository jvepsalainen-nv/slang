//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#ifelse
//META: purpose=Boundary: the ternary `?:` expression also lowers to the structured ifElse terminator — the surface-level expression form produces the same four-operand structured tuple as the statement form.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A ternary `(a > b) ? a : b` is a value-producing expression but the
// LOWER-TO-IR pass still emits the structured ifElse, with the two
// arms branching to a merge block whose block-param receives the
// per-arm value.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (a > b) ? a : b;
}

// CHECK-LABEL: func %main
// CHECK: cmpGT(%a, %b)
// CHECK: ifElse(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}})
// CHECK: unconditionalBranch(%{{[0-9]+}}, %a)
// CHECK: unconditionalBranch(%{{[0-9]+}}, %b)
