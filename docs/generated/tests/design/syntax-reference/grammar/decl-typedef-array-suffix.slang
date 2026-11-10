//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#variable--binding-declarations
//META: purpose=`Declarator` folds a trailing `ArraySuffix` onto a `typedef` alias type, so `typedef int Pair[2];` parses.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the shared Declarator machinery in TypedefDecl: the alias
// name carries a trailing `[2]` suffix that must fold onto the alias
// type. A variable of the alias type is indexed like an int[2], which
// only works if the suffix became part of the aliased type.

//TEST:INTERPRET(filecheck=CHECK):

typedef int Pair[2];

void main()
{
    Pair p;
    p[0] = 40;
    p[1] = 2;
    // CHECK: r=42
    printf("r=%d\n", p[0] + p[1]);
}
