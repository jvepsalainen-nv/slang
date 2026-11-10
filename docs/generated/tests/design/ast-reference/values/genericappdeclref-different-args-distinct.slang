//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#declref-family
//META: purpose=A generic decl-ref with its arguments applied is identified by the argument list, so the same generic decl applied to different arguments denotes distinct types and cross-assignment is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative half of generic-application identity: `Box<int>`
// and `Box<float>` share a generic decl but differ in their argument
// list. CHECK pins the type-mismatch diagnostic (E30019) naming both
// spellings, which proves the two applications did not collapse to one
// type despite the shared decl.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Box<T> { T v; }

void main()
{
    Box<int> bi;
    Box<float> bf = bi;
//CHECK:            ^^ expected an expression of type 'Box<float>', got 'Box<int>'
//CHECK: E30019
}
