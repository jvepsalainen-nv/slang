//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Unsigned 64-bit overflow wraps: `UINT64_MAX + 1 == 0`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The wrap-on-overflow rule applied to uint64_t at the documented
// MAX edge.

//TEST:INTERPRET(filecheck=CHECK):

uint64_t addOne(uint64_t x) { return x + 1; }

void main()
{
    uint64_t v = addOne(18446744073709551615ULL);
    //CHECK: wrap=0
    printf("wrap=%llu\n", v);
}
