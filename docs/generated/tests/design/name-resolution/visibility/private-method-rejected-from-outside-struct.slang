//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=A `private` method is not visible outside its enclosing aggregate; an overload call from a free function is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-keyword semantics: `private` methods are filtered out by
// `TryCheckOverloadCandidateVisibility` during overload resolution.
// A free function attempting the call gets `not accessible`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S
{
    private int helper() { return 1; }
}

void test(S s)
{
    int x = s.helper();
/*CHECK:
              ^^^^^^ declaration not accessible
              ^^^^^^ 'helper' is not accessible from the current context.
*/
// CHECK: E30600
}
