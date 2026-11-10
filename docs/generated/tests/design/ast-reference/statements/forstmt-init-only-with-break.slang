//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#loop-family
//META: purpose=A ForStmt with empty predicateExpression and empty sideEffectExpression (`for (init; ; )`) loops indefinitely; a body-internal break terminates it after the documented number of iterations.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: ForStmt with null `predicateExpression` and null
// `sideEffectExpression` slots, only the initialStatement is present.
// The documented role is `for (init; cond; step) body`; missing
// `cond` is treated as constant-true. A break inside the body must
// still exit the LoopStmt.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int hits = 0;
    for (int i = 0; ; )
    {
        hits = hits + 1;
        if (hits >= 3) { break; }
        i = i + 1;
    }
    // CHECK: hits=3
    printf("hits=%d\n", hits);
}
