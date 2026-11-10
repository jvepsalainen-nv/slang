//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#typealignment--the-operand-order-exception
//META: purpose=A TypeAlignment attribute reads the alignment from operand 0 and omits the layout-unit operand for the byte default, unlike the kind-first size and offset attributes.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented exception to the kind-first convention. The struct
// is 48 bytes aligned to 16 and its `float` field is aligned to 4, so two
// distinct alignment attributes exist; each prints with a single operand whose
// value is the alignment itself. Reading operand 0 as a resource kind -- the
// habit `size` and `offset` teach -- would see 16 and 4 as kind enumerators,
// which is exactly the confusion this shape guards against.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct S
{
    float a;
    float4 b;
    int c;
}

ConstantBuffer<S> cb;
RWStructuredBuffer<float> buf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    buf[0] = cb.a + cb.b.x + float(cb.c);
}

// CHECK-DAG: = TypeAlignment(16 : Int)
// CHECK-DAG: = TypeAlignment(4 : Int)
// A byte-unit size still spells the kind first, for contrast.
// CHECK-DAG: = size(8 : Int, 48 : Int)
