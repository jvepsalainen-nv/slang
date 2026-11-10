//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of Int64 lowers to a field(...) row carrying Int64.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of Int64 lowers to a field(...) row carrying Int64.
// Two `int64_t` fields surface two `field(%key, Int64)` rows.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Range64 { int64_t lo; int64_t hi; }

uniform Range64 r;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(r.lo) + int(r.hi);
}

// IR-LABEL: struct %Range64
// IR: field(%{{.*}}, Int64)
