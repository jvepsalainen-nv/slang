//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=Boundary probe of `##`: pasting an identifier with the empty token sequence yields just that identifier.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `JOIN(my_value, )` — the right operand of `##` is the empty token
// sequence. The paste must collapse to just the left operand, so
// the resulting identifier is `my_value`. If the paste produced an
// invalid token (or an extra trailing token), the lookup `my_value`
// would not resolve to the static constant.

//TEST:INTERPRET(filecheck=CHECK):

#define JOIN_(a, b) a##b
#define JOIN(a, b) JOIN_(a, b)

static const int my_value = 88;

void main()
{
    // CHECK: pasted=88
    printf("pasted=%d\n", JOIN(my_value,));
}
