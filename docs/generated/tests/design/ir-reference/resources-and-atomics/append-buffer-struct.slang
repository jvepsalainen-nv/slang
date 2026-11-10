//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#append-and-consume-buffers
//META: purpose=`AppendStructuredBuffer<S>::Append(s)` on a struct element type still lowers to a single `StructuredBufferAppend(%buf, %s)` opcode regardless of element-type shape.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the element operand stays a single value even when the
// element type is an aggregate. A two-field struct is appended, and the
// CHECK requires one `StructuredBufferAppend(%abuf, ...)` under
// `func %main` — the struct is not split into per-field appends.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Item { int a; float b; }
uniform AppendStructuredBuffer<Item> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    Item it;
    it.a = idx;
    it.b = (float)idx;
    abuf.Append(it);
    rwbuf[idx] = idx;
}

// IR-LABEL: func %main
// IR: StructuredBufferAppend(%abuf, {{.*}})
