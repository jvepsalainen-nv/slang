//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`TypedefDecl` parses as `'typedef' Type Declarator ';'` (C-style order: type before the alias declarator).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the C-style TypedefDecl production with the simplest
// declarator (a bare IDENT): `typedef Type Name;`. The order is
// reversed from `typealias` — type first, alias declarator second —
// and the typedef'd name is usable as a type.

//TEST:INTERPRET(filecheck=CHECK):

typedef int Distance;

void main()
{
    Distance d = 7;
    // CHECK: d=7
    printf("d=%d\n", d);
}
