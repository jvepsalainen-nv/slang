//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#overloading
//META: purpose=When an overloaded identifier cannot be disambiguated at the call site, the compiler emits an ambiguous-call error (E39999).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two overloads where neither is strictly preferred for the given argument types.
// The call `foo(1, 1)` cannot disambiguate between foo(int,float) and foo(float,int),
// so an ambiguous-call error must be reported at the use site.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -entry computeMain -stage compute

void foo(int x, float y) {}
void foo(float x, int y) {}

[numthreads(1, 1, 1)]
void computeMain()
{
    foo(1, 1);
    //CHECK: E39999
}
