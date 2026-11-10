//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#implicit-lookup
//META: purpose=Implicit `this` lookup works inside extension methods — bare field names resolve to `this.field`.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that implicit `this` lookup works inside an extension method body.
// Bare `width` and `height` in `Box.area()` must resolve to `this.width` and
// `this.height` without explicit qualification. CHECK asserts the result is 24
// (4*6), proving both names resolved through implicit `this` in the extension.
//TEST:INTERPRET(filecheck=CHECK):

struct Box { int width; int height; }

extension Box
{
    int area()
    {
        // 'width' and 'height' are bare identifier expressions resolving via implicit this.
        return width * height;
    }
}

void main()
{
    Box b;
    b.width = 4;
    b.height = 6;
    int a = b.area();
    //CHECK: 24
    printf("%d\n", a);
}
