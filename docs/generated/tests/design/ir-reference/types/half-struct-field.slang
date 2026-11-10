//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of Half lowers to a field(...) row carrying Half.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of Half lowers to a field(...) row carrying Half. A
// struct holding a `half` field produces a `field(%key, Half)` row.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct HalfBox { half value; }

uniform HalfBox h;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(h.value);
}

// IR-LABEL: struct %HalfBox
// IR: field(%{{.*}}, Half)
