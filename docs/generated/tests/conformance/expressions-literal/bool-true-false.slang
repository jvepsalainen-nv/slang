//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#boolean-literal-expressions
//META: purpose=Boolean literal: `true` and `false` are the only spellings; each is a `bool` r-value with the documented truth value.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's `BooleanLiteral` production is exactly
// `'true' | 'false'`. Verify both values parse, are bool-typed
// (via overload resolution), and print the documented value.

//TEST:INTERPRET(filecheck=CHECK):

int probe(bool x) { return x ? 1 : 0; }
int probe(int x) { return -1; }

void main()
{
    int t = probe(true);
    int f = probe(false);
    //CHECK: t=1 f=0
    printf("t=%d f=%d\n", t, f);
}
