//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#function-style-declarations
//META: purpose=`Param` parses with an optional `'=' Expr` default-value clause.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a function parameter accepts a default-value clause
// (`Type IDENT '=' Expr`). Calling the function without that argument
// uses the default.

//TEST:INTERPRET(filecheck=CHECK):

int addOne(int x, int k = 1) { return x + k; }

void main()
{
    // CHECK: r=8
    printf("r=%d\n", addOne(7));
}
