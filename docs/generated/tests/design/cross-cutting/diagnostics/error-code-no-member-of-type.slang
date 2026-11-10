//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A missing struct member renders E30027 with the member name interpolated.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `no-member-of-name-in-type` (30027) to its rendered code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
struct S { int x; };
void main()
{
    S s;
    s.y = 3;
/*CHECK:
      ^ E30027
      ^ 'y' is not a member of 'S'.
*/
}
