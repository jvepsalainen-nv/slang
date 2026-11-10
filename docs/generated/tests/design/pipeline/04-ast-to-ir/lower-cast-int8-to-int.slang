//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An explicit `int(int8Value)` cast lowers to `intCast(%int8)` — narrow-to-wide signed integer conversion in the int-to-int family.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: explicit-cast axis — int8 to int. The existing
// `cast-uint-from-int-...` test covers `uint(int)`; this one
// pins the narrow-integer-to-int form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int8_t i8;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(i8);
}

// CHECK-LABEL: func %main
// CHECK: Int{{.*}}= intCast(%{{.*}})
