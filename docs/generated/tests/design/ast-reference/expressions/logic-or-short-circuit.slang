//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A LogicOperatorShortCircuitExpr `||` does not evaluate the right operand when the left is true.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Dual of the `&&` short-circuit: when the left operand of `||` is
// true, the right operand must not be evaluated. We use a
// counter-incrementing right operand to make non-evaluation observable.

//TEST:INTERPRET(filecheck=CHECK):

bool bump(inout int counter) { counter++; return false; }

void main()
{
    int counter = 0;
    bool r1 = (true) || bump(counter);
    // CHECK: counter-after-true-or=0
    printf("counter-after-true-or=%d\n", counter);

    bool r2 = (false) || bump(counter);
    // CHECK: counter-after-false-or=1
    printf("counter-after-false-or=%d\n", counter);
}
