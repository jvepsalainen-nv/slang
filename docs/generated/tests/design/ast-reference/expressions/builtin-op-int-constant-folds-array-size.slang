//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#builtinoperatorexpr
//META: purpose=A binary builtin operator on integer scalar operands resolves to a single operation kind and constant-folds: `(13 & 6) | 1` is accepted as an array dimension and evaluates to 5.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that builtin bitwise operators on integer scalars are resolved
// to their operation kind once and reach the constant folder: the value of
// `(13 & 6) | 1` is demanded in an array-dimension position, which requires
// a compile-time-known integer. The program only compiles if folding
// succeeded, and CHECK asserts the folded value 5 at runtime.

//TEST:INTERPRET(filecheck=CHECK):

static const int kFolded = (13 & 6) | 1;

void main()
{
    // Array dimension forces compile-time evaluation of kFolded.
    int arr[kFolded];
    arr[0] = kFolded;
    // CHECK: folded=5
    printf("folded=%d\n", arr[0]);
}
