//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#aggtypedecl-structdecl-classdecl-enumdecl
//META: purpose=A ClassDecl declares a reference-type aggregate constructed with `new`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a class is the reference-type aggregate variant, allocated
// with `new` rather than copied like a struct. The interpreter cannot
// instantiate classes, so the observation point is the emitted C++ text; the
// CHECK pins the `new C` allocation, which only appears for a reference type.
//
// The result has to be observed for the test to mean anything. If nothing
// reads `a`, dead-code elimination drops the allocation and the emitted entry
// point body is empty, so the CHECK has nothing to match against -- storing
// `a.v` into a buffer is what keeps the allocation live all the way to emit.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

class C
{
    int v;
    __init(int x) { v = x; }
}

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1,1,1)]
void main()
{
    //CHECK: new C
    C a = new C(7);
    gOut[0] = a.v;
}
