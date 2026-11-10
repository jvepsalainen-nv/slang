//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#block-and-param
//META: purpose=Short-circuit && emits an ifElse whose arms each branch to the after-block carrying the arm's value, and the after-block declares a param to receive it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the front end already uses the block-parameter (phi-replacement)
// convention for a short-circuiting `&&` rather than leaving it to a later
// SSA pass. The CHECK binds the ifElse's afterBlock operand and then requires
// both arms to reach exactly that block through an unconditionalBranch that
// carries one argument -- the true arm passes the evaluated right operand,
// the short-circuit arm passes the literal `false` -- and that the block
// opens with a `param`. Only the predecessor-carries-the-argument encoding
// produces that shape.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    bool r = (a > 0) && (b > 0);
    buf[0] = r ? 1 : 0;
}

// CHECK-LABEL: func %main
// CHECK: cmpGT(%a, 0 : Int)
// CHECK: ifElse(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, %[[MERGE:[0-9]+]])
// The true arm evaluates the right operand and hands it to the merge block.
// CHECK: unconditionalBranch(%[[MERGE]], %{{[0-9]+}})
// The short-circuit arm hands the constant `false` to the same block.
// CHECK: unconditionalBranch(%[[MERGE]], false)
// CHECK: block %[[MERGE]](
// CHECK: param %r
