//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#partial-generic-application
//META: purpose=An explicit ordinary generic-argument prefix pins the leading parameters while call-site inference solves the remaining ones together.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the explicit prefix and the inferred remainder are solved
// together rather than requiring the caller to spell out every generic
// argument. `g<int>` pins T and leaves U to be deduced from the float
// argument. CHECK asserts the call resolved and returned its tag.

//TEST:INTERPRET(filecheck=CHECK):

int g<T, U>(T a, U b) { return 1; }

void main()
{
    int tag = g<int>(1, 2.0f);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
