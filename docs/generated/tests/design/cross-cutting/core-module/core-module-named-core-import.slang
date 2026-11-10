//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#core-module
//META: purpose=The core module is one identified Slang module named `core`, so `import core;` resolves to the already-loaded builtin module and core declarations stay usable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core module is a single module whose declared name is
// `core`. Naming it in an `import` must resolve against the builtin
// module the compiler already loaded rather than searching the disk for
// a `core.slang`; the CHECK asserts the program still runs and that a
// core-declared alias (`int32_t`) is usable afterwards, which only
// holds if the import bound the builtin module.

//TEST:INTERPRET(filecheck=CHECK):

import core;

void main()
{
    int32_t v = int32_t(7);
    // CHECK: core-imported v=7
    printf("core-imported v=%d\n", v);
}
