//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Boundary: a single-field struct surfaces exactly one `field` row under the parent.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a single-field struct surfaces exactly one `field` row under the
// parent. The minimum nontrivial member count (1) surfaces exactly one
// `field(%key, <T>)` row.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Single { int x; }

uniform Single s;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = s.x;
}

// IR-LABEL: struct %Single
// IR: field(%{{.*}}, Int)
