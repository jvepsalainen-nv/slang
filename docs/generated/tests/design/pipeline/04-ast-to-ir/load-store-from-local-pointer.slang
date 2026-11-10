//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=An assignment to a struct field lowers to a `store(%addr, %value)`; reading the field back lowers to a `load(%addr)`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Combined with the `IRVar` row: a struct local has its field
// written via `store(%addr, %v)` and read via `load(%addr)`. This is
// an end-to-end probe of the doc's memory-instruction row from the
// AST-side: assignment to a member, then read of the member.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Pair { int x; int y; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Pair p;
    p.x = a;
    p.y = a + 1;
    buf[0] = p.x + p.y;
}

// CHECK-LABEL: func %main
// CHECK: store(%{{.*}}, %{{.*}})
// CHECK: load(%{{.*}})
