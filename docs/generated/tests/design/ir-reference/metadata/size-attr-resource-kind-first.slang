//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#size-and-offset
//META: purpose=A size attribute puts the LayoutResourceKind in operand 0 and the size in operand 1, so one type layout can carry a separate size per kind.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the kind-first convention on `size`. A parameter block holding both
// byte-sized data and resources gives its struct layout two size attributes;
// the CHECKs capture the first two operands of that struct layout and show
// each is a `size` whose leading operand is a different kind enumerator, which
// is only readable if the kind is operand 0.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct Params
{
    float4 a;
    Texture2D t;
    SamplerState s;
}

ParameterBlock<Params> gPB;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = gPB.a.x;
}

// CHECK: = structTypeLayout(%[[S0:[0-9]+]], %[[S1:[0-9]+]], %{{[0-9]+}}
// CHECK-DAG: %[[S0]]{{.*}}= size(8 : Int, 16 : Int)
// CHECK-DAG: %[[S1]]{{.*}}= size(9 : Int, 2 : Int)
