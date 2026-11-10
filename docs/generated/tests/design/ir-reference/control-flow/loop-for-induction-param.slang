//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#loop
//META: purpose=A for-loop lowers to loop(body, break, continue, ...) with the three structured-join operands plus initial values for body-block induction params.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A canonical for-loop accumulator surfaces the loop terminator. The
// loop body block then receives the induction variables as `param`
// declarations — Slang IR's encoding of SSA phi.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        s = s + i;
    }
    buf[0] = s;
}

// CHECK-LABEL: func %main
// CHECK: loop(%{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}}, 0 : Int, 0 : Int)
// CHECK: param %s	: Int
// CHECK: param %i	: Int
