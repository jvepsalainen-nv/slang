//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#top-level-structure
//META: purpose=`ModuleHeader` accepts `'module' ';'` with the name omitted, falling back to the current module name.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a module header may omit the module name entirely:
// `module;` starts the file and the rest of the program still parses
// and runs, which is only possible if the nameless header is accepted.

//TEST:INTERPRET(filecheck=CHECK):

module;

void main()
{
    // CHECK: ok=1
    printf("ok=%d\n", 1);
}
