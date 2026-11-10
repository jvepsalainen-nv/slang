//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#select
//META: purpose=A scalar-conditioned ternary `?:` inside a function does NOT lower to `select`; it lowers to an `ifElse` with then/else blocks and a join-block `param`, because Slang's scalar `?:` short-circuits.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the complementary half of the `select` condition rule: with
// a plain `bool` condition the arms must be evaluated lazily, so a
// branch-free opcode is not allowed. CHECK asserts the emitted shape is
// `ifElse` followed by a join block carrying an `Int` `param`, and
// asserts no `select(` appears in the function at all — the absence is
// the observation that distinguishes this case from the `bool3` one.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform bool c;
uniform int x;
uniform int y;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = c ? x : y;
}

// IR-LABEL: func %main
// IR: ifElse(%c,
// IR: param %{{[A-Za-z0-9_]+}}	: Int
// IR-NOT: select(
