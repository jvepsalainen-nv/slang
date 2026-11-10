//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#extensions
//META: purpose=The body of an extension may not include variable declarations; attempting to add a non-static member variable in an extension is a compile error (E31400).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that adding a non-static member variable inside an extension is rejected.
// Extensions cannot change a type's in-memory layout; declaring `extraField` inside
// `extension MyVec` must trigger E31400, confirmed by CHECK-DAG.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

struct MyVec { float x, y; }

extension MyVec
{
    int extraField;
}

void main() {}

// CHECK-DAG: error
// CHECK-DAG: E31400
