//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=Boundary: `-warnings-as-errors all` promotes every surviving warning to `error`, not just one selected id.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `all` boundary of the warnings-as-errors promotion: rather than
// naming one id, the request covers every warning that survives the earlier
// severity steps. Two unrelated warnings are triggered in one file and the
// annotations assert both are reported at severity `error`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-warnings-as-errors all
int main()
{
    int x = (1, 2);
//CHECK:      ^ error
//CHECK:      ^ comma operator used in expression
    int enum = x;
//CHECK:^^^^ error
//CHECK:^^^^ is a type keyword
    return enum;
}
