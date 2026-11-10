//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#type-queries-and-predicates
//META: purpose=`__isBindlessTextureNVEncodable<T>()` folds to true for a texture or sampler type and false for a scalar or vector.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `IsBindlessTextureNVEncodable` predicate row: it folds to a
// compile-time boolean once `T` is concrete, true for texture and sampler types
// and false for plain numeric types.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[9 9 9 9 9], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = __isBindlessTextureNVEncodable<Texture2D<float>>() ? 1 : 0;
    outputBuffer[1] = __isBindlessTextureNVEncodable<SamplerState>() ? 1 : 0;
    outputBuffer[2] = __isBindlessTextureNVEncodable<float>() ? 1 : 0;
    outputBuffer[3] = __isBindlessTextureNVEncodable<float4>() ? 1 : 0;
}

// CHECK: 1
// CHECK-NEXT: 1
// CHECK-NEXT: 0
// CHECK-NEXT: 0
