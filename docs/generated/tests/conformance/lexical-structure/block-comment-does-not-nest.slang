//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#comments
//META: purpose=Block comments do not nest per the explicit doc note "Block comments do not nest." Verify by relying on the OUTER `*/` to close even when an inner `/*` precedes.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that block comments do not nest: the first `*/` ends the
// comment regardless of any preceding `/*` inside it. The test places
// `/* /* */ int valid = 42;` in the body — if nesting were supported,
// the declaration would still be inside the comment and `valid` would
// be undefined. CHECK observing `valid=42` proves non-nesting.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    /* /* */ int valid = 42;
    //CHECK: valid=42
    printf("valid=%d\n", valid);
}
