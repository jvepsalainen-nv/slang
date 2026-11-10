//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=Signed 32-bit overflow wraps per the doc's "All arithmetic operations on signed and unsigned integers wrap on overflow": `INT_MAX + 1 == INT_MIN`.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's #integer-types section states: "All arithmetic
// operations on signed and unsigned integers wrap on overflow."
// Verify at the documented MAX edge: `INT_MAX + 1` wraps to `INT_MIN`.
// The operand is passed through a function to defeat the constant
// folder (see _common.md § Defeat the optimizer).

//TEST:INTERPRET(filecheck=CHECK):

int addOne(int x) { return x + 1; }

void main()
{
    int v = addOne(2147483647);
    //CHECK: wrap=-2147483648
    printf("wrap=%d\n", v);
}
