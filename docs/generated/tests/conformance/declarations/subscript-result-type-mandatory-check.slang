//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#subscripts
//META: purpose=The result type clause of a `__subscript` declaration cannot be elided; a `__subscript` without `->` is a compile error (E30901).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that omitting the `->` result type from a `__subscript` is a compile error.
// A subscript without an explicit return type must trigger E30901; CHECK-DAG asserts
// both the error severity and the diagnostic code.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

struct Bad
{
    __subscript(int i)
    {
        get { return 0; }
    }
}

void main() {}

// CHECK-DAG: error
// CHECK-DAG: E30901
