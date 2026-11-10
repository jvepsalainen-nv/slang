//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#func
//META: purpose=Boundary: a function returning a user struct names that struct as the Func result-type operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a function returning a user struct names that struct as the Func
// result-type operand. When the function returns a user struct, the
// `Func(%Pair, Int)` form names the struct's IR identity in the
// result-type slot — distinct from the basic-scalar smoke test.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Pair { int a; int b; }

uniform int x;
uniform RWStructuredBuffer<int> buf;

Pair makePair(int v) { Pair p; p.a = v; p.b = v + 1; return p; }

[numthreads(1, 1, 1)]
void main()
{
    Pair p = makePair(x);
    buf[0] = p.a + p.b;
}

// IR-LABEL: func %makePair
// IR-SAME: Func(%Pair, Int)
