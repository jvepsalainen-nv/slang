//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#linkage-and-lifetime
//META: purpose=A top-level struct declaration carries an export decoration recording its mangled type-linkage name (prefix _ST).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `export` covers type declarations too, and that the type
// namespace has its own mangled prefix. The CHECK pins `_ST` plus the
// struct identifier, then the `struct %WidgetData` line the decoration
// precedes.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

struct WidgetData
{
    int payload;
};

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    WidgetData w;
    w.payload = int(tid.x);
    buf[0] = w.payload;
}

// CHECK: [export("_ST{{.*}}WidgetData{{.*}}")]
// CHECK: [nameHint("WidgetData")]
// CHECK: struct %WidgetData
