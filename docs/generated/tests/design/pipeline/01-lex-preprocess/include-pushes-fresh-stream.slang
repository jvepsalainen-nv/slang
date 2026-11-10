//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#include-resolution
//META: purpose=`#include` resolves the named string against `IncludeSystem` and pushes a fresh input stream so the file's tokens become part of the enclosing translation unit.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an `#include`d file contributes its declarations to
// the parent unit. The helper header defines `included_value`; if
// the include were not resolved, the reference here would not
// compile.

//TEST:INTERPRET(filecheck=CHECK):

#include "include-pushes-fresh-stream.slang.h"

void main()
{
    // CHECK: included=91
    printf("included=%d\n", included_value);
}
