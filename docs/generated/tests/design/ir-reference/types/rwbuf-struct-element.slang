//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=Boundary: RWStructuredBuffer parameterised by a user struct names that struct as its first operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWStructuredBuffer parameterised by a user struct names that struct
// as its first operand. Its element-type operand can be any value type
// — including a user struct — and the dump preserves the struct's IR
// identity as that first operand.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Particle { float3 pos; float mass; int alive; }

uniform RWStructuredBuffer<Particle> particles;
uniform float a;

[numthreads(1, 1, 1)]
void main()
{
    particles[0].mass = a;
}

// IR: let {{.*}}%particles{{.*}}: RWStructuredBuffer(%Particle{{.*}}= global_param
