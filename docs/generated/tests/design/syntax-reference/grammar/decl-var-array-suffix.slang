//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=`VarDeclarator` accepts an `ArraySuffix` of the form `'[' Expr ']'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a C-style VarDecl declarator parses an ArraySuffix
// `[N]`. The element is then read via the subscript postfix.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int xs[3] = { 10, 20, 30 };
    // CHECK: mid=20
    printf("mid=%d\n", xs[1]);
}
