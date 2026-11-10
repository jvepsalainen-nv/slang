//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#modifier-parsing
//META: purpose=Modifier tokens collected before a decl keyword attach to the resulting Decl through the Modifier chain rooted at ModifiableSyntaxNode; `static const int K = 21;` declares a usable compile-time-known binding.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `static` and `const` are modifier tokens that precede the `int K`
// declaration. The parser collects both into the Modifier chain on
// the VarDecl; the binding is then usable at any later point.

//TEST:INTERPRET(filecheck=CHECK):

static const int K = 21;

void main()
{
    int r = K + K;
    // CHECK: r=42
    printf("r=%d\n", r);
}
