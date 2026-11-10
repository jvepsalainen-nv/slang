//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#spir-v-literals-and-kinds
//META: purpose=A generic type-parameter is typed type_t in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A generic type-parameter is typed type_t in the IR dump. A `T
// identity<T>(T x)` declaration shows `param %T : type_t` inside the
// surrounding `generic` instruction.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

T identity<T>(T x) { return x; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = identity<int>(a);
}

// IR: generic
// IR: param %T {{.*}} type_t
