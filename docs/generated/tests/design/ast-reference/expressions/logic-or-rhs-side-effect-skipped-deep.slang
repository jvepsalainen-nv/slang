//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Stresses LogicOperatorShortCircuitExpr `||`: a leading `true` must skip three chained side-effecting right operands.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Deeply chained `||`. Once the leftmost operand is true, none of
// the three subsequent calls to `bump` may execute.

//TEST:INTERPRET(filecheck=CHECK):

bool bump(inout int c) { c++; return false; }

void main()
{
    int c = 0;
    bool _ = (true) || bump(c) || bump(c) || bump(c);
    // CHECK: c=0
    printf("c=%d\n", c);
}
