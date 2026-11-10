//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=`VarDecl` accepts the C-style form `Type VarDeclarator (',' VarDeclarator)* ';'` with an `Initializer`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the C-style VarDecl production with multiple declarators in
// a single statement, each with its own `'=' Expr` initializer.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 2, b = 3;
    // CHECK: a=2,b=3
    printf("a=%d,b=%d\n", a, b);
}
