//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=The same generic-struct requirement is accepted when the compile target does provide the required capability.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive side of the same check, so the negative test cannot
// pass for an unrelated reason. The identical program is compiled for the
// target the struct requires; CHECK asserts the emitted C++ contains the
// entry-point function, which only happens if validation let it through.

//TEST:SIMPLE(filecheck=CHECK): -target cpp -entry main -stage vertex

[require(cpp)]
struct Foo<T>
{
    T value;
}

[shader("vertex")]
void main(Foo<int> a)
{
}
// CHECK: main
