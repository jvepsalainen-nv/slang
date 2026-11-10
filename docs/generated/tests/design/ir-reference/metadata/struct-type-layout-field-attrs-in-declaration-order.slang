//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#layout-family
//META: purpose=A structTypeLayout carries one structFieldLayout attribute per field, and those attributes appear in field declaration order.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-field attribute tail and its ordering. `struct S` has three
// fields declared a, b, c; the CHECK captures the five operands of the
// `structTypeLayout` (two layout attributes followed by three field
// attributes) and then resolves each captured field operand by name. Because
// the capture fixes the position, matching `%a` on the third operand, `%b` on
// the fourth and `%c` on the fifth is what proves declaration order.

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

// CHECK: = structTypeLayout(%{{[0-9]+}}, %{{[0-9]+}}, %[[FA:[0-9]+]], %[[FB:[0-9]+]], %[[FC:[0-9]+]])
// CHECK-DAG: %[[FA]]{{.*}}= structFieldLayout(%a,
// CHECK-DAG: %[[FB]]{{.*}}= structFieldLayout(%b,
// CHECK-DAG: %[[FC]]{{.*}}= structFieldLayout(%c,
