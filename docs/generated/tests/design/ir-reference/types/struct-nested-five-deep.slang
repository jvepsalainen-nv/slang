//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Stress: five-deep struct nesting produces five distinct `struct %Name` parent opcodes.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// five-deep struct nesting produces five distinct `struct %Name`
// parent opcodes. Five levels of nesting surface five distinct
// `struct` opcodes in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct A { int x; }
struct B { A inner; int y; }
struct C { B inner; int z; }
struct D { C inner; int w; }
struct E { D inner; int v; }

uniform E e;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = e.inner.inner.inner.inner.x;
}

// IR: struct %A
// IR: struct %B
// IR: struct %C
// IR: struct %D
// IR: struct %E
