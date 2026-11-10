//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Boundary: an empty struct still surfaces a parent `struct %Name` opcode (no field children).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// an empty struct still surfaces a parent `struct %Name` opcode (no
// field children). A struct with zero fields still emits the parent
// `struct %Name` IR opcode — the container exists even when empty.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Empty {}

uniform RWStructuredBuffer<int> buf;

void useIt(Empty e) {}

[numthreads(1, 1, 1)]
void main()
{
    Empty e;
    useIt(e);
    buf[0] = 0;
}

// IR-LABEL: struct %Empty
