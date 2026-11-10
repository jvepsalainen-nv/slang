//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#edge-cases-and-failure-modes
//META: purpose=Two Applicable candidates that tie on every comparator step are both kept in bestCandidates and reported as an ambiguous call.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ambiguity path. Two same-signature functions live in sibling
// namespaces that are both brought into scope, so cost, specificity and scope
// distance all tie and the comparator returns equal. CHECK pins the ambiguous
// call error at the call site.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

namespace A { int act(int x) { return 1; } }
namespace B { int act(int x) { return 2; } }

using namespace A;
using namespace B;

void main()
{
    int v = act(7);
//CHECK:       ^ ambiguous call to 'act'
    printf("%d\n", v);
}
