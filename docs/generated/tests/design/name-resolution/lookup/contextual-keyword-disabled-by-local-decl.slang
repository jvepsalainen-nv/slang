//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#keyword-vs-identifier
//META: purpose=A contextual keyword is only available when plain lookup of that identifier finds nothing, so a user local of the same spelling makes the parser treat the token as an ordinary identifier.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that keywords and user decls share one identifier namespace
// and lookup decides between them. `each` is a contextual keyword that
// introduces a pack-expansion element; with no local of that name the
// same text is a syntax error outside an `expand`. Declaring a local
// `each` makes lookup succeed, which disables the keyword. CHECK
// asserts 41 + 1, so the token was read as the variable.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int each = 41;
    int r = each + 1;
    // CHECK: r=42
    printf("r=%d\n", r);
}
