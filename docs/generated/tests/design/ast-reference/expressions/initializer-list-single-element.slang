//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that a single-element InitializerListExpr `{99}` populates the sole field of a one-field aggregate.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimal non-empty boundary for InitializerListExpr.args: exactly
// one element. The positional rule still applies for a single-field
// aggregate.

//TEST:INTERPRET(filecheck=CHECK):

struct One { int v; }

void main()
{
    One o = {99};
    // CHECK: v=99
    printf("v=%d\n", o.v);
}
