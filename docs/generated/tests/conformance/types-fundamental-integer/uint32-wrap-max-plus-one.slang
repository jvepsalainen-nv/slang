//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Unsigned 32-bit overflow wraps: `UINT_MAX + 1 == 0` per the doc's wrap-on-overflow rule.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's #integer-types section explicitly covers unsigned
// wrap: "All arithmetic operations on signed and unsigned integers
// wrap on overflow." Verify at the uint32 MAX edge.

//TEST:INTERPRET(filecheck=CHECK):

uint addOne(uint x) { return x + 1; }

void main()
{
    uint v = addOne(4294967295u);
    //CHECK: wrap=0
    printf("wrap=%u\n", v);
}
