//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#func
//META: purpose=A user-named helper function lowers to func %helper with the signature on its Func(...) result type and parameters as Param children of the entry block.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two halves of the `func` shape at once: the declared signature
// is the inst's own `Func(returnType, paramTypes...)` result type, and the
// declared parameters are `param` children of the entry block (not operands of
// `func`). CHECK pins `func %addPair : Func(Int, Int, Int)` and then the two
// `param` lines that follow inside the body.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

int addPair(int x, int y)
{
    return x + y;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = addPair(a, b);
}

// CHECK: func %addPair	: Func(Int, Int, Int)
// CHECK: param %x	: Int
// CHECK: param %y	: Int
