//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=`LetDecl` parses as `'let' IDENT (':' Type)? ('=' ArgExpr)? ';'`, binding a value without a type annotation.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the LetDecl production with the optional type annotation
// elided. The bound value is observed via printf.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    let x = 13;
    // CHECK: x=13
    printf("x=%d\n", x);
}
