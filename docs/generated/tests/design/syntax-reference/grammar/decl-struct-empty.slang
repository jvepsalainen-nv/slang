//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`StructDecl` parses as `'struct' IDENT '{' '}'` with an empty member list.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the smallest legal `StructDecl` production: keyword `struct`,
// identifier, empty brace-delimited body. If the production failed to
// parse the empty body, declaration or usage at module scope would
// fail.

//TEST:INTERPRET(filecheck=CHECK):

struct Empty {}

void main()
{
    Empty e;
    // CHECK: ok
    printf("ok\n");
}
