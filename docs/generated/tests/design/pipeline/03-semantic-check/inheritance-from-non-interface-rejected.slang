//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Inheritance checking rejects a struct that names a sealed builtin type as its base (E30831).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "inheritance and extension lookup" concern. `int` is a sealed
// builtin, so listing it in an inheritance clause is not a legal base;
// CHECK pins E30831 plus the accompanying unstable-inheritance warning the
// same clause triggers.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Derived : int
{
    int d;
}
//CHECK: E30831
//CHECK: E30816

void main()
{
}
