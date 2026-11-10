//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#compiletimeforstmt
//META: purpose=A CompileTimeForStmt over a 32-element range unrolls to 32 copies of the body; the summed loop-variable values match the closed-form 0+1+...+31 = 496.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: a 32-iteration compile-time unroll. Verifies the body is
// instantiated once per value of the range with the loop variable bound
// to that value. The CHECK asserts the accumulated sum equals the
// closed form 0+1+...+31 = 496, which only matches if every iteration
// was emitted exactly once.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    $for(i in Range(32))
    {
        sum = sum + i;
    }
    // CHECK: sum=496
    printf("sum=%d\n", sum);
}
