//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Suffix `ULL` selects `uint64_t` per the documented table; `1ULL` resolves the `uint64_t` overload.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's suffix table maps `ULL`/`LLU` on a decimal value to
// `uint64_t`. Overload resolution distinguishes the type at the call
// site.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int x) { return 1; }
int probe(uint x) { return 2; }
int probe(int64_t x) { return 3; }
int probe(uint64_t x) { return 4; }

void main()
{
    int picked = probe(1ULL);
    //CHECK: picked=4
    printf("picked=%d\n", picked);
}
