//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Signed 32-bit underflow wraps: `INT_MIN - 1 == INT_MAX`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's "wrap on overflow" rule applies to underflow too
// (overflow is the signed-arithmetic abstraction that includes both
// directions). Verify at MIN edge: `INT_MIN - 1` wraps to `INT_MAX`.

//TEST:INTERPRET(filecheck=CHECK):

int subOne(int x) { return x - 1; }

void main()
{
    int v = subOne(-2147483648);
    //CHECK: wrap=2147483647
    printf("wrap=%d\n", v);
}
