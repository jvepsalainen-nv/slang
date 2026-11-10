//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#defaultconstruct
//META: purpose=Default-initialising a vector or matrix does not emit `defaultConstruct`; lowering decomposes the result type first and builds the concrete aggregate (`MakeVectorFromScalar` / `makeMatrixFromScalar`) from a zero literal.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "avoided rather than emitted" property of
// `defaultConstruct`: for a type it can decompose, lowering never
// reaches the nullary opcode. `float3 z = {}` and `float2x2 m = {}` are
// the two decomposable cases; both results are read into an output
// buffer so neither is dead. CHECK asserts the zero-literal splat
// opcodes appear with a `0 : Float` operand and that `defaultConstruct`
// does not appear at all — the absence is what proves the decomposition
// happened rather than a fallback.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float3 z = {};
    float2x2 m = {};
    buf[tid.x] = z.y + m[1][0];
}

// IR-LABEL: func %main
// IR-DAG: : Vec(Float, 3 : Int)	= MakeVectorFromScalar(0 : Float)
// IR-DAG: : Mat(Float, 2 : Int, 2 : Int, {{.*}})	= makeMatrixFromScalar(0 : Float)
// IR-NOT: defaultConstruct
