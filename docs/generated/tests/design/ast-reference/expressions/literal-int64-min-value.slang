//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that the int64 MIN literal -9223372036854775808 is accepted and round-trips as that exact value rather than being diagnosed as too large.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A leading `-` is a prefix operator rather than part of the literal token,
// so the magnitude 9223372036854775808 on its own does not fit any signed
// type; only the signed-minimum carve-out lets the folded result be typed as
// int64_t. The CHECK asserts the exact value survives, which fails if the
// magnitude were diagnosed or wrapped.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int64_t v = -9223372036854775808;
    // CHECK: v=-9223372036854775808
    printf("v=%lld\n", v);
}
