//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#edge-cases-and-failure-modes
//META: purpose=A `private` decl declared directly inside a `namespace` is rejected with `invalid private visibility` because the diagnostic requires membership in a type, not merely a container.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the boundary of the "declaring container" wording for `private`: a
// namespace is a container, but a namespace member is still a global decl,
// so the declaration-site check rejects it before any use site is reached.
// The CHECK pins E30603 with the message that names membership in a *type*
// as the requirement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

namespace Grouped
{
    private int hidden() { return 1; }
/*CHECK:
    ^^^^^^^ invalid private visibility
    ^^^^^^^ 'hidden' cannot have private visibility because it is not a member of a type.
*/
// CHECK: E30603
}
