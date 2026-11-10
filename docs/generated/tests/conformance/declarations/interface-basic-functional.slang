//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#interfaces
//META: purpose=An interface declaration introduces requirements; a type conforming to the interface must provide matching implementations.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a struct conforming to an interface must implement all interface requirements.
// `ConstRNG : IRandom` provides `next()`; calling it and checking 42 proves the
// conformance was accepted and the implementation dispatched.

//TEST:INTERPRET(filecheck=CHECK):

interface IRandom
{
    uint next();
}

struct ConstRNG : IRandom
{
    uint seed;
    uint next() { return seed; }
}

void main()
{
    ConstRNG rng;
    rng.seed = 42;
    // CHECK: 42
    printf("%u\n", rng.next());
}
