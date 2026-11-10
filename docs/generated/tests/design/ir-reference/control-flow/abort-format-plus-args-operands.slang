//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#abort
//META: purpose=The front-end-emitted Abort carries the format string plus the variadic argument pack: call arguments after the format ride on the Abort as a single makeValuePack operand holding them.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the variadic side of the Abort operand shape: passing two
// uniform-derived values after the format string produces an Abort
// whose second operand is the variadic argument pack — a
// makeValuePack of type TypePack(Int, Int) built from exactly those
// two values. Capturing the pack's id ties the Abort operand to the
// pack that packages the call arguments, and the format literal is
// pinned inline on the Abort itself. Uniform operands keep the
// arguments from constant-folding away.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    if (a > b)
        abort("bounds: a=%d b=%d", a, b);
    buf[0] = a + b;
}

// CHECK: let %[[PACK:[0-9a-zA-Z_]+]] : TypePack(Int, Int) = makeValuePack(%a, %b)
// CHECK-LABEL: func %main
// CHECK: Abort("bounds: a=%d b=%d", %[[PACK]])
