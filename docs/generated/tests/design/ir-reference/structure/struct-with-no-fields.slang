//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#struct-internals
//META: purpose=A struct with no members lowers to a childless struct parent, printed as a declaration terminated by a semicolon rather than a brace-delimited body.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Exercises the zero end of the field-count axis. `struct Empty {}` has nothing
// for `getFields()` to return, and the dump distinguishes a childless parent by
// terminating the header with `;` instead of opening a `{ ... }` block. CHECK
// pins that spelling, so a stray synthesized field would fail the match.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;
uniform int seed;

struct Empty {}

int sizeProbe(Empty e, int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main()
{
    Empty e;
    buf[0] = sizeProbe(e, seed);
}

// CHECK: struct %Empty	: Type;
