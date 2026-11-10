//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Signed 64-bit overflow wraps: `INT64_MAX + 1 == INT64_MIN`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's wrap-on-overflow rule extends to int64_t. The
// MIN value here exercises the smallest-negative-int64 carve-out in
// the literal spec too (sibling bundle expressions-literal covers
// that interaction explicitly).

//TEST:INTERPRET(filecheck=CHECK):

int64_t addOne(int64_t x) { return x + 1; }

void main()
{
    int64_t v = addOne(9223372036854775807LL);
    //CHECK: wrap=-9223372036854775808
    printf("wrap=%lld\n", v);
}
