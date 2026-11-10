//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#global-scope-type-layout
//META: purpose=When the global scope is wrapped in a parameter group such as a cbuffer, the module's layout is a parameterGroupTypeLayout rather than a bare structTypeLayout.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the wrapped branch of the global-scope type layout. Declaring a
// `cbuffer` puts the global scope inside a parameter group, so the layout
// builder wraps the struct layout. CHECK asserts a
// `parameterGroupTypeLayout(` instruction appears in the merged layout
// block, which only the wrapped path emits.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

cbuffer CB { float4 color; }
uniform RWStructuredBuffer<float4> result;

[numthreads(1, 1, 1)]
void main()
{
    result[0] = color;
}

// CHECK-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CHECK: parameterGroupTypeLayout(
