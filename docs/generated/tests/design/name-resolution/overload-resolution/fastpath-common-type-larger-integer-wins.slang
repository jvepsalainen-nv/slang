//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=Among integer operands the larger size wins, so an int + int64_t expression has type int64_t.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "larger size wins" rule of the fast path's common-type
// computation at the 32-bit/64-bit boundary. An overload probe on `int` versus
// `int64_t` observes the type of `a + b`; CHECK asserts the int64_t overload
// fired.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int x)     { return 1; }
int probe(int64_t x) { return 2; }

void main()
{
    int a = 3;
    int64_t b = 4;
    int tag = probe(a + b);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
