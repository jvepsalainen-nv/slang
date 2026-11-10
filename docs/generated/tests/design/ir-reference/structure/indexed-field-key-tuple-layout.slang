//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#struct-internals
//META: purpose=Layout lowering keys the fields of a tuple-like type with indexedFieldKey insts carrying the base type and the field index.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the only producer of `indexedFieldKey`: layout lowering of a
// tuple-like type that has no materialized `struct` to supply real keys. A
// `Tuple<int, float>` shader parameter forces a layout to be computed for it;
// the CHECK-DAGs require one placeholder key per element, each naming the
// tuple type and the element index it stands for.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;
uniform Tuple<int, float> tup;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = tup._0 + int(tup._1);
}

// CHECK-DAG: indexedFieldKey(tuple_type(Int, Float), 0 : Int)
// CHECK-DAG: indexedFieldKey(tuple_type(Int, Float), 1 : Int)
