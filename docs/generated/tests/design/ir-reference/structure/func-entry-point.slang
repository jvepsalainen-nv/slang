//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#func
//META: purpose=An entry-point function lowers to a func parent opcode whose Func(...) result type carries the signature.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a function is a `func` parent inst whose signature lives on
// its own result type rather than in an operand list. The compute entry point
// `main` takes nothing and returns nothing, so CHECK asserts the dump header
// reads `func %main : Func(Void)` — a `Func(...)` result type with only the
// return type in it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = 1;
}

// CHECK: func %main	: Func(Void)
