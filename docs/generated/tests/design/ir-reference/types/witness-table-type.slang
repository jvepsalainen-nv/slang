//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#witness-table-types
//META: purpose=A conformance produces a witness_table value whose IR type is witness_table_t(<interface>) with witness_table_entry rows.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A conformance produces a witness_table value whose IR type is
// witness_table_t(<interface>) with witness_table_entry rows. The
// conformance of `Square : IShape` emits `witness_table %... :
// witness_table_t(%IShape)(%Square)` with one `witness_table_entry`
// per requirement.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IShape { float area(); }
struct Square : IShape { float side; float area() { return side * side; } }

uniform float s;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    Square sq = { s };
    buf[0] = sq.area();
}

// IR: witness_table %{{.*}}: witness_table_t(%IShape)(%Square)
// IR: witness_table_entry(%{{.*}}
