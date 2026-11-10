//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#control-flow-instructions
//META: purpose=A `for` loop lowers to the `loop` terminator and uses block `param`s to carry the SSA induction value.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies two control-flow claims at once: the `loop` terminator (in
// the `TerminatorInst` family) is produced for a `for` loop, and the
// loop header carries `param` declarations ("Block or function
// parameter; replaces SSA phi").

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int sum = 0;
    for (int i = 0; i < n; i++)
        sum += i;
    buf[0] = sum;
}

// IR-LABEL: func %main
// IR: loop(%{{.*}}, %{{.*}}, %{{.*}}{{.*}})
// IR: param %{{.*}}
