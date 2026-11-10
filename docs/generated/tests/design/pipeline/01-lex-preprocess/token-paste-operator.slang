//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=The token-paste operator `x##y` synthesizes a fresh single token formed by concatenating the spellings of its two operands.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `x##y` glues two tokens into one identifier. Here
// `MAKE_NAME(my, value)` must paste to `my_value`. If the paste
// operator did not produce a single identifier token, the parser
// would see two tokens or an invalid token and the test would not
// compile.

//TEST:INTERPRET(filecheck=CHECK):

#define PASTE_(a, b) a##_##b
#define PASTE(a, b) PASTE_(a, b)

static const int PASTE(my, value) = 77;

void main()
{
    // CHECK: pasted=77
    printf("pasted=%d\n", my_value);
}
