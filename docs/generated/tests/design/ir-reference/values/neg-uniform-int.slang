//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: prefix `-` on a `uniform int` (whose value spans the full signed-32 range, including the documented MIN where unary negation overflows) lowers to `neg(%a)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The neg opcode is exercised in the smoke test through compound
// expressions. This boundary probe isolates `-a` on a uniform —
// the `a` operand's value is unknown to the compiler, so the
// `neg(MIN)` overflow edge is preserved as a single `neg`
// instruction. Lowering does not pre-bake the overflow path.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = -a;
}

// IR-LABEL: func %main
// IR: neg(%a)
