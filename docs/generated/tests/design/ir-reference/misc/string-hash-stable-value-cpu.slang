//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#getstringhash
//META: purpose=`getStringHash` of the same literal produces the same value at every call site, and different literals produce different values.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the hash is a function of the literal's bytes and nothing
// else. Two separate helper functions hash an identical literal and a third
// hashes a different one; the kernel writes 1 when the first two agree and 1
// again when the third differs. Both assertions are needed — equality alone
// would also hold for a degenerate hash that returned a constant.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

uint hashSiteA() { return getStringHash("stable-key-123"); }
uint hashSiteB() { return getStringHash("stable-key-123"); }
uint hashOther() { return getStringHash("other-key-456"); }

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = (hashSiteA() == hashSiteB()) ? 1 : 0;
    outputBuffer[1] = (hashSiteA() != hashOther()) ? 1 : 0;
}

// CHECK: 1
// CHECK: 1
