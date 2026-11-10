//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#ptr-and-the-access-qualifier--address-space-operands
//META: purpose=Boundary: a get_field_addr through a nested struct field yields a value of type Ptr(<InnerStruct>).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a get_field_addr through a nested struct field yields a value of
// type Ptr(<InnerStruct>). When a local nested-struct field is
// accessed by address, the inner `get_field_addr` produces a
// `Ptr(%Foo)` whose pointee is the inner struct type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Foo { int x; }
struct Bar { Foo f; int y; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Bar b;
    b.f.x = a;
    b.y = a + 1;
    buf[0] = b.f.x + b.y;
}

// IR: let {{.*}}: Ptr(%Foo){{.*}}= get_field_addr
