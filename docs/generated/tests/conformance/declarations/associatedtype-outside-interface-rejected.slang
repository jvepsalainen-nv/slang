//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#associated-types
//META: purpose=It is an error to declare an `associatedtype` anywhere other than the body of an interface declaration; the compiler rejects it with E30102.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `associatedtype` outside an interface body is a compile error.
// Placing it inside a `struct` must trigger E30102; CHECK-DAG confirms both the
// error severity and the exact diagnostic code.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

struct Foo
{
    associatedtype Elem;
}

void main() {}

// CHECK-DAG: error
// CHECK-DAG: E30102
