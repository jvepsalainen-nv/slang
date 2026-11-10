//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=A user struct lowers to a parent `struct %Name` opcode containing `field(%key, <T>)` rows.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A user struct lowers to a parent `struct %Name` opcode containing
// `field(%key, <T>)` rows.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Mixed { int x; float y; bool z; }

uniform Mixed s;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (s.z ? 1.0 : 0.0) + float(s.x) + s.y;
}

// IR-LABEL: struct %Mixed
// IR: field(%{{.*}}, Int)
// IR: field(%{{.*}}, Float)
// IR: field(%{{.*}}, Bool)
