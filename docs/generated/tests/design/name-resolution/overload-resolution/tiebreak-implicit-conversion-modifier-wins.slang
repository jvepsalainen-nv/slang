//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#tie-breaking-comparator
//META: purpose=When exactly one of two otherwise-tied candidates carries ImplicitConversionModifier, that candidate wins instead of the pair being reported ambiguous.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the implicit-conversion-preference step. The same two-namespace
// shape that is reported ambiguous without the modifier resolves cleanly once
// one candidate is marked __implicit_conversion, and it is the marked one that
// wins regardless of declaration order. CHECK asserts the marked candidate's
// tag, which here belongs to the *second* namespace.

//TEST:INTERPRET(filecheck=CHECK):

namespace A { int act(int x) { return 1; } }
namespace B { __implicit_conversion(0) int act(int x) { return 2; } }

using namespace A;
using namespace B;

void main()
{
    int tag = act(7);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
