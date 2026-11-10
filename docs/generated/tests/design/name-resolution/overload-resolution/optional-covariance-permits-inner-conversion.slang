//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversions-that-do-not-have-their-own-cost-level
//META: purpose=Optional<T> to Optional<U> covariance recursively probes the inner conversion, so an Optional<int> argument reaches an Optional<float> parameter.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that Optional-to-Optional coercion is not restricted to an exact
// inner-type match: the inner int-to-float conversion is probed and charged,
// making the single candidate applicable. CHECK asserts the callee ran, which
// only happens if the covariant form was accepted.

//TEST:INTERPRET(filecheck=CHECK):

int consume(Optional<float> o) { return 1; }

void main()
{
    Optional<int> oi = 5;
    int tag = consume(oi);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
