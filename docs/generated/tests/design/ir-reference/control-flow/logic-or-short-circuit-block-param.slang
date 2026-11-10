//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#block-and-param
//META: purpose=Short-circuit || emits an ifElse whose short-circuit arm branches to the after-block carrying the literal true, and the after-block declares a param to receive it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `||` half of the same block-parameter convention, which
// inverts which arm is the short-circuit one: for `||` the true arm hands
// the literal `true` straight to the merge block and the false arm evaluates
// the right operand. The CHECK binds the ifElse afterBlock operand and pins
// both branch argument shapes plus the receiving `param`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    bool r = (a > 0) || (b > 0);
    buf[0] = r ? 1 : 0;
}

// CHECK-LABEL: func %main
// CHECK: cmpGT(%a, 0 : Int)
// CHECK: ifElse(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, %[[MERGE:[0-9]+]])
// CHECK: unconditionalBranch(%[[MERGE]], true)
// CHECK: cmpGT(%b, 0 : Int)
// CHECK: unconditionalBranch(%[[MERGE]], %{{[0-9]+}})
// CHECK: block %[[MERGE]](
// CHECK: param %r
