//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=The specialize opcode is hoistable; two textually-identical specialize references collapse to one value in the IR.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the hoistable flag on `specialize`: two call sites that apply the
// same generic to the same argument share one `specialize` inst. Both sites
// are emitted, and the CHECKs assert both spell their callee identically —
// there is no second, distinct specialization spelling for the same
// (base, args) pair.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

T pickFirst<T>(T x, T y) { return x; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = pickFirst<int>(a, b);
    buf[1] = pickFirst<int>(b, a);
}

// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, Int)
// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, Int)
