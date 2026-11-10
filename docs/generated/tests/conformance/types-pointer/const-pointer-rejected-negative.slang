//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=The `const T*` C-style const pointer declaration is rejected with E20017; the compiler suggests `Ptr<T, Access.Read>` or `let`/`const Ptr<...>` instead.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `const T*` C-style const pointer syntax is rejected.
// Declares a `const int*` and checks that E20017 fires; proves the
// compiler enforces the language restriction rather than silently accepting it.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target cpp

void main()
{
    int x = 5;
    const int* p = &x;
//CHECK: E20017
}
