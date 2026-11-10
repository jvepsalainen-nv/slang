//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: purpose=Boundary: right-shift by 0 (`a >> 0`) lowers to `shr(%a, 0 : Int)` — the lower edge of the shift-amount axis on the `shr` opcode.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge of the shift-amount axis on `shr`. The signed
// operand exercises the documented "arithmetic shift" key.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = a >> 0;
}

// IR-LABEL: func %main
// IR: shr(%a, 0 : Int)
