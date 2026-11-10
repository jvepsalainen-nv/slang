//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Boundary: minimum non-trivial array size (1) appears as Array(Int, 1 : Int) in the IR.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// minimum non-trivial array size (1) appears as Array(Int, 1 : Int) in
// the IR. The smallest nontrivial extent (1) surfaces as `Array(Int, 1
// : Int)` on the dumped field.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Holder { int data[1]; }
uniform Holder s;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = s.data[0];
}

// IR-LABEL: struct %Holder
// IR: field(%{{.*}}, Array(Int, 1 : Int))
