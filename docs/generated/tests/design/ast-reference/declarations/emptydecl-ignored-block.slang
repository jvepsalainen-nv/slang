//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=An `__ignored_block { ... }` is skipped wholesale and leaves behind an empty declaration.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the contents of an ignored block are consumed without being
// parsed as Slang. The block contains text that is not a valid declaration; if
// it were parsed the file would not compile. The CHECK asserts the entry
// point's output, proving the block was skipped and left nothing behind.

//TEST:INTERPRET(filecheck=CHECK):

__ignored_block { this text is not a slang declaration at all (a, b) }

void main()
{
    //CHECK: ok
    printf("ok\n");
}
