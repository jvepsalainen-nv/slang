//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#macro-expansion
//META: purpose=Inside an inactive `#if` block, only directives that may toggle the active/inactive state (`#if`, `#ifdef`, `#ifndef`, `#else`, `#elif`, `#endif`) are evaluated; other directives are skipped without effect.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `#define` inside an inactive `#if 0` block is NOT
// evaluated. After the conditional, the macro must remain undefined
// — the `#ifdef SECRET` test must take the `#else` branch and yield
// 0. If the inactive-branch directive were evaluated, `SECRET` would
// be defined and the printed value would be 1.

//TEST:INTERPRET(filecheck=CHECK):

#if 0
#define SECRET
#endif

#ifdef SECRET
static const int picked = 1;
#else
static const int picked = 0;
#endif

void main()
{
    // CHECK: picked=0
    printf("picked=%d\n", picked);
}
