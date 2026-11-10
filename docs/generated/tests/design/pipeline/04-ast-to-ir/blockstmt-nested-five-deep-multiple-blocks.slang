//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A function with five-deep nested IfStmts lowers each level to its own `ifElse(...)` terminator; the body grows into many basic blocks (then / else / merge per level).
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress: control-flow depth axis. With five nested `if` levels the
// IR contains five distinct `ifElse(...)` terminators in sequence —
// one per nesting level — and the function body decomposes into
// many basic blocks. Pattern verifies five ifElse occurrences
// inside `%main`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int r = 0;
    if (a > 0) {
        if (a > 1) {
            if (a > 2) {
                if (a > 3) {
                    if (a > 4) {
                        r = 5;
                    }
                }
            }
        }
    }
    buf[0] = r;
}

// CHECK-LABEL: func %main
// CHECK: ifElse(
// CHECK: ifElse(
// CHECK: ifElse(
// CHECK: ifElse(
// CHECK: ifElse(
