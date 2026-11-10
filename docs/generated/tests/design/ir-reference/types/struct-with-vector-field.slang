//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Boundary: a struct field of vector type composes; the field row carries the full Vec(...) operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of vector type composes; the field row carries the
// full Vec(...) operand. A `float4 v;` field surfaces `field(%key,
// Vec(Float, 4 : Int))` — composition between the `struct` and `Vec`
// opcodes.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Holder { float4 v; }

uniform Holder s;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = s.v.x;
}

// IR-LABEL: struct %Holder
// IR: field(%{{.*}}, Vec(Float, 4 : Int))
