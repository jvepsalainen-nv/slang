//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`StructuredBuffer::GetDimensions(count, stride)` does not reach `func %main` as the `StructuredBufferGetDimensions` opcode — lowering leaves a call whose two `out` parameters are passed as `var` pointers, and the opcode appears only inside the library body.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies where the dimensions query sits relative to user code. Both
// `out` arguments are written back into an output buffer so nothing is
// dead. The IR directive pins the call under `func %main`, and the
// second, unanchored directive shows the opcode itself does exist in the
// dump — inside the specialized library function, not in the user body.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main
//TEST:SIMPLE(filecheck=OPC):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint count;
    uint stride;
    sbuf.GetDimensions(count, stride);
    rwbuf[tid.x] = count + stride;
}

// IR-LABEL: func %main
// IR: call {{.*}}(%sbuf, %count, %stride)

// OPC: StructuredBufferGetDimensions(%{{[A-Za-z0-9_]+}})
