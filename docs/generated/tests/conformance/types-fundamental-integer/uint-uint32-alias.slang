//META: generated=true
//META: doc_ref=docs/language-reference/types-fundamental.md#integer
//META: purpose=`uint` and `uint32_t` are spec-level aliases.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's #integer-types table lists `uint` and `uint32_t`
// together. Verify a value declared as one is directly assignable
// to and equal to the same value typed as the other.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    uint a = 4294967290u;
    uint32_t b = a;
    uint c = b;
    bool eq = (a == b) && (b == c) && (a == c);
    //CHECK: a=4294967290 b=4294967290 c=4294967290 eq=1
    printf("a=%u b=%u c=%u eq=%d\n", a, b, c, eq ? 1 : 0);
}
