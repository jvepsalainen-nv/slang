//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`EnumDecl` parses `'enum' IDENT '{' EnumCase (',' EnumCase)* ','? '}'` with an optional trailing comma.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the EnumDecl production: an enum with two cases, a trailing
// comma, and a case that has an explicit `= Expr` initializer.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red = 1, Green, Blue, }

void main()
{
    // The enum parses with three cases and a trailing comma. We observe
    // the parse succeeded by exercising case equality (which requires the
    // identifiers to have been bound).
    Color c = Color.Green;
    int r = (c == Color.Red) ? 1 : (c == Color.Blue) ? 3 : 2;
    // CHECK: c=2
    printf("c=%d\n", r);
}
