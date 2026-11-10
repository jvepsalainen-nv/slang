//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#top-level-structure
//META: purpose=`ModuleName` accepts a `STRING_LIT` alternative in a `module` header.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the string-literal module-name spelling: `module "name";`
// uses a STRING_LIT (which can carry characters an identifier cannot,
// like `-`) and the file still parses and runs.

//TEST:INTERPRET(filecheck=CHECK):

module "grammar-bundle-string-name";

void main()
{
    // CHECK: ok=3
    printf("ok=%d\n", 3);
}
