//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A SubscriptDecl makes the type indexable; `a[i]` invokes the subscript's get accessor.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `__subscript` turns index syntax into a call of the declared
// accessor. The accessor body maps index 1 to the second field, and the CHECK
// asserts that field's value, so index syntax must have reached the accessor
// rather than any built-in array indexing.

//TEST:INTERPRET(filecheck=CHECK):

struct Triple
{
    int a, b, c;
    __subscript(int i) -> int
    {
        get
        {
            if (i == 0) return a;
            if (i == 1) return b;
            return c;
        }
    }
}

void main()
{
    Triple t;
    t.a = 10; t.b = 20; t.c = 30;
    //CHECK: 20
    printf("%d\n", t[1]);
}
