//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=On an integer size tie the unsigned type wins, so an int + uint expression has type uint.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the size-tie arm of the fast path's common-type rule: `int` and
// `uint` are the same width, so the unsigned type is chosen. An overload probe
// distinguishes int, uint and float results; CHECK asserts the uint overload
// fired.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int x)   { return 1; }
int probe(uint x)  { return 2; }
int probe(float x) { return 3; }

void main()
{
    int a = 3;
    uint b = 4u;
    int tag = probe(a + b);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
