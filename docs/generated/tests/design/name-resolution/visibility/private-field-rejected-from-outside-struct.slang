//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=A `private` field is not visible outside its enclosing aggregate; access from a free function is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-keyword semantics: `private` is visible only inside the same
// aggregate. A free function cannot reach a private field; lookup
// finds the candidate then `filterLookupResultByVisibilityAndDiagnose`
// rejects it with `declaration not accessible`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S
{
    private int secret;
}

void test(S s)
{
    int x = s.secret;
/*CHECK:
              ^^^^^^ declaration not accessible
              ^^^^^^ 'secret' is not accessible from the current context.
*/
// CHECK: E30600
}
