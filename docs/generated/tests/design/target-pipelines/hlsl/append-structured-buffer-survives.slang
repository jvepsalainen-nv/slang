//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-b-specialization-and-type-legalization
//META: purpose=lowerAppendConsumeStructuredBuffers is skipped for HLSL because HLSL has native Append/Consume types; the type spellings survive.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL has native `AppendStructuredBuffer<T>` and
// `ConsumeStructuredBuffer<T>` types, so Slang does NOT lower
// them; the emit retains both type names and the `.Append()` /
// `.Consume()` method calls.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

AppendStructuredBuffer<int> appendBuf;
ConsumeStructuredBuffer<int> consumeBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    int x = consumeBuf.Consume();
    appendBuf.Append(x + 1);
}

// CHECK-DAG: AppendStructuredBuffer<int{{.*}}> appendBuf_{{[0-9]+}}
// CHECK-DAG: ConsumeStructuredBuffer<int{{.*}}> consumeBuf_{{[0-9]+}}
// CHECK: .Consume()
// CHECK: .Append(
