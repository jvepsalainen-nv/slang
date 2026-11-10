//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=Boundary: `typedef` is the C-style decl keyword listed alongside `typealias`; the alias resolves to its underlying type for overload resolution just like `typealias`.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pairs with `decl-typealias.slang` to cover both spellings the
// decl-keywords table lists (`typedef` -> `parseTypeDef`,
// `typealias` -> `parseTypeAliasDecl`).

//TEST:INTERPRET(filecheck=CHECK):

typedef int MyInt;

int kind(int v)  { return 1; }
int kind(uint v) { return 2; }

void main()
{
    MyInt x = 99;
    // CHECK: k=1
    printf("k=%d\n", kind(x));
}
