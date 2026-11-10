//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Unsigned 32-bit underflow wraps: `0u - 1u == UINT_MAX`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc's wrap-on-overflow rule covers underflow in the unsigned
// direction: subtracting from zero wraps to UINT_MAX.

//TEST:INTERPRET(filecheck=CHECK):

uint subOne(uint x) { return x - 1; }

void main()
{
    uint v = subOne(0u);
    //CHECK: wrap=4294967295
    printf("wrap=%u\n", v);
}
