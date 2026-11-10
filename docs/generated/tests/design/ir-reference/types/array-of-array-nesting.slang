//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Stress: array-of-array nests Array operands; int[3][4] surfaces as Array(Array(Int, 4 : Int), 3 : Int).
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// array-of-array nests Array operands; int[3][4] surfaces as
// Array(Array(Int, 4 : Int), 3 : Int). The outer extent appears as the
// second operand of the outermost `Array`; the inner extent appears in
// the nested `Array`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Nest { int data[3][4]; }
uniform Nest s;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = s.data[0][0];
}

// IR-LABEL: struct %Nest
// IR: field(%{{.*}}, Array(Array(Int, 4 : Int), 3 : Int))
