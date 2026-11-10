//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`TypeAliasDecl` parses as `'typealias' IDENT '=' Type ';'`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the TypeAliasDecl production: `typealias Name = Type;`. The
// alias is then used as a type in a variable declaration.

//TEST:INTERPRET(filecheck=CHECK):

typealias MyInt = int;

void main()
{
    MyInt x = 42;
    // CHECK: x=42
    printf("x=%d\n", x);
}
