//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=A mixed-type shift is declined by the fast path and resolved by the general path, which keeps the type of the left operand rather than a common type.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fast path's mixed-type-shift carve-out: `a << b` does not go
// through the common-type rule, so a 64-bit left operand shifted by a 32-bit
// amount keeps its 64-bit type. An overload probe on `int` versus `int64_t`
// observes the type of the shift; CHECK asserts the int64_t overload fired.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int64_t x) { return 1; }
int probe(int x)     { return 2; }

void main()
{
    int64_t a = 3;
    int amount = 1;
    int tag = probe(a << amount);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
