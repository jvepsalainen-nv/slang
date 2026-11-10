//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`namespace name { ... }` is a decl keyword introducing a named scope whose members are reached with `::` qualification.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Declare a `namespace nest` containing a function, then call it from
// `main` via the `::` qualified-name form documented in
// `tokens.md`.

//TEST:INTERPRET(filecheck=CHECK):

namespace nest
{
    int answer() { return 42; }
}

void main()
{
    // CHECK: a=42
    printf("a=%d\n", nest::answer());
}
