//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#finalize-phase-completeoverloadcandidate
//META: purpose=CompleteOverloadCandidate rebuilds the callee by replaying the lookup item's breadcrumb chain, so an interface-bounded generic call dispatches to the conforming type's implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the callee-construction half of the finalize phase for an
// interface-requirement candidate: the breadcrumb chain the lookup left behind
// is what turns `s.kind()` into a witness-table dispatch on T. Two conforming
// types return distinct tags; CHECK asserts each call reached its own
// implementation.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape { int kind(); }

struct Square : IShape { int kind() { return 4; } }
struct Triangle : IShape { int kind() { return 3; } }

int describe<T : IShape>(T s) { return s.kind(); }

void main()
{
    Square sq;
    Triangle tr;
    int a = describe(sq);
    int b = describe(tr);
    // CHECK: a=4 b=3
    printf("a=%d b=%d\n", a, b);
}
