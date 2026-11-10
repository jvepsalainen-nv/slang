//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#function-and-module-structure
//META: purpose=A source function declaration lowers to a `func` inst whose children are `block`s.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `func`/`IRFunc` structure row ("Function; children
// are blocks") together with the `block` control-flow row. The
// user-named helper `computeIt` appears as `func %computeIt` in the IR,
// and its body opens with a `block`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int computeIt(int x) { return x + x; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = computeIt(a);
}

// IR: func %computeIt
// IR: block %{{.*}}
