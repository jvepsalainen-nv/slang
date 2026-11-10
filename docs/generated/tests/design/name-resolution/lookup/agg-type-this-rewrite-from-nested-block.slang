//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=When the scope walk reaches an enclosing aggregate type it rewrites the request into member lookup with an implicit this breadcrumb, and that rewrite still fires from several block scopes deep inside a method body.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the container-kind dispatch of the scope walk on its
// deepest documented shape: the reference to the field `x` sits two
// nested blocks inside the method, so the walk crosses both block
// scopes before it recognizes the struct container and rewrites the
// request into a member lookup carrying the implicit `this`. CHECK
// asserts 50 + 3, which only comes out if `x` bound to the receiver's
// field rather than failing to resolve.

//TEST:INTERPRET(filecheck=CHECK):

struct P
{
    int x;
    int complicated(int n)
    {
        {
            {
                return x + n;
            }
        }
    }
}

void main()
{
    P p;
    p.x = 50;
    // CHECK: r=53
    printf("r=%d\n", p.complicated(3));
}
