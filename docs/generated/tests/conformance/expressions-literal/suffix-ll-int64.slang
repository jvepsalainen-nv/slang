//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Suffix `LL` selects `int64_t` first per the documented table; `1LL` resolves the `int64_t` overload.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's suffix table maps `LL` on a small decimal value to
// `int64_t`. Overload resolution distinguishes the type at the call
// site.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int x) { return 1; }
int probe(uint x) { return 2; }
int probe(int64_t x) { return 3; }
int probe(uint64_t x) { return 4; }

void main()
{
    int picked = probe(1LL);
    //CHECK: picked=3
    printf("picked=%d\n", picked);
}
