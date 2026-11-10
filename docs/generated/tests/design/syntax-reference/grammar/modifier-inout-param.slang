//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#modifiers
//META: purpose=`ModifierKeyword` includes `inout`, which attaches to a `Param`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an `inout` modifier on a parameter parses and produces
// a pass-by-reference binding observable at the call site.

//TEST:INTERPRET(filecheck=CHECK):

void inc(inout int x) { x = x + 1; }

void main()
{
    int v = 10;
    inc(v);
    // CHECK: v=11
    printf("v=%d\n", v);
}
