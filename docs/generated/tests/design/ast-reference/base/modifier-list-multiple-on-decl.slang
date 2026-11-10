//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#modifier-syntaxnode
//META: purpose=Modifiers form a list on the node they adorn, so several modifiers stack onto one declaration and every one of them takes effect.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a declaration keeps every modifier written in front of
// it. `bump` carries both `[mutating]` and `[ForceInline]`; the
// mutating write is the observable one. CHECK asserts the counter
// advanced twice, which requires `[mutating]` to have survived being
// followed by a second modifier in the list.

//TEST:INTERPRET(filecheck=CHECK):

struct Counter
{
    int n;

    [mutating]
    [ForceInline]
    void bump()
    {
        n = n + 1;
    }
};

void main()
{
    Counter c;
    c.n = 10;
    c.bump();
    c.bump();
    //CHECK: n=12
    printf("n=%d\n", c.n);
}
