//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A write through a nested struct member chains additional OpAccessChain steps and emits an Offset 8 on the outer struct member (the documented Offset decoration per member).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: chained struct member access through a nested struct.
// SPIR-V represents this as additional OpAccessChain steps; each
// inner member carries its own OpMemberDecorate Offset.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

struct Inner
{
    float a;
    float b;
}

struct Outer
{
    Inner inner;
    float c;
}

RWStructuredBuffer<Outer> buf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x].inner.a = float(tid.x);
}

// CHECK-DAG: OpMemberDecorate %Outer{{[A-Za-z_0-9]*}} 1 Offset 8
// CHECK-DAG: OpAccessChain %{{[A-Za-z_0-9]+}} %buf %int_0
