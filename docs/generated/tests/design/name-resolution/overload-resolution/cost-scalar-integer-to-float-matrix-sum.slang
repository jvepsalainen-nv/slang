//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_ScalarIntegerToFloatMatrix (410) is the sum of the int-to-float and scalar-to-matrix levels, so an int scalar prefers an int2x2 parameter (10) over a float2x2 one.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the composite 410 level really is 400 + 10 rather than a
// cheaper special case. An int scalar broadcast into int2x2 pays only the
// scalar-to-matrix 10, while float2x2 pays 410; CHECK asserts the int-matrix
// overload's tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(float2x2 m) { return 1; }
int pick(int2x2 m)   { return 2; }

void main()
{
    int v = 3;
    int tag = pick(v);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
