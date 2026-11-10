//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#witness-table-types
//META: purpose=Stress: two distinct conformances to the same interface produce two distinct witness_table values parameterised by the same interface.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// two distinct conformances to the same interface produce two distinct
// witness_table values parameterised by the same interface. Two struct
// conformances against the same interface produce two distinct
// `witness_table` values whose types both share
// `witness_table_t(%IShape)` but differ in the concrete-type
// parenthesised application.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IShape { float area(); }
struct Circle : IShape { float r; float area() { return 3.14 * r * r; } }
struct Square : IShape { float s; float area() { return s * s; } }

uniform float r;
uniform float s;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    Circle c = { r };
    Square sq = { s };
    buf[0] = c.area() + sq.area();
}

// IR: witness_table %{{.*}}: witness_table_t(%IShape)(%Circle)
// IR: witness_table %{{.*}}: witness_table_t(%IShape)(%Square)
