//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#control-flow-instructions
//META: purpose=A value-returning function terminates its block with the `return_val` terminator.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `return_val` terminator row. A helper function that
// returns a computed value ends its block with `return_val(%v)` in the
// IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

int addThem(int x, int y) { return x + y; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = addThem(a, b);
}

// IR: return_val(%{{.*}})
