//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ModernParamDecl written in the name-first spelling is immutable unless marked `out`/`inout`; assigning to it is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the immutability half of the modern (name-first) parameter form.
// The parameter is declared `x: int` with no direction qualifier and the body
// assigns to it; the CHECK pins the l-value diagnostic, which is what makes
// the modern parameter's default immutability observable.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

func bump(x: int) -> int
{
    x = x + 1;
/*CHECK:
      ^ left of '=' is not an l-value
*/
//CHECK: E30011
    return x;
}

void main() {}
