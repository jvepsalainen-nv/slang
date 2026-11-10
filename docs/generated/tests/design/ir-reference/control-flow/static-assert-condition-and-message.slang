//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#other-control-flow-opcodes
//META: purpose=A static_assert call lowers to the StaticAssert instruction carrying the condition value and the message string as its two operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the StaticAssert row: the builtin becomes a two-operand
// instruction sitting as an ordinary member of the block rather than a
// terminator, and the message survives lowering as a string literal operand.
// The condition is written over a `static const` so it is a genuine value
// operand in the dump; the CHECK binds the comparison result and requires
// StaticAssert's first operand to be exactly that value.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;
static const int K = 4;

[numthreads(1, 1, 1)]
void main()
{
    static_assert(K == 4, "K must be 4");
    buf[0] = n;
}

// CHECK-LABEL: func %main
// CHECK: [[COND:%[0-9]+]]{{.*}}= cmpEQ(%K, 4 : Int)
// CHECK: StaticAssert([[COND]], "K must be 4")
