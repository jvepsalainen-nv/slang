//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_OneVectorToScalar (1) makes a one-element vector argument reach a scalar parameter implicitly.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one-vector-to-scalar row of the cost table. A vector<float,1>
// argument is accepted by a plain float parameter, which is only possible if
// the downcast is a permitted implicit conversion; CHECK asserts the value the
// callee computed from the downcast element.

//TEST:INTERPRET(filecheck=CHECK):

int pick(float x) { return int(x) + 1; }

void main()
{
    vector<float, 1> v = vector<float, 1>(41.0f);
    int tag = pick(v);
    // CHECK: tag=42
    printf("tag=%d\n", tag);
}
