// main.cpp

// This file provides the application code for the `hello-world-metal` example.
//
// This example uses Metal to run a simple compute shader written in Slang.
// The goal is to demonstrate how to use the Slang API to cross compile
// shader code to Metal Shading Language (MSL).
//
#include "examples/example-base/example-base.h"
#include "examples/example-base/test-base.h"
#include "slang-com-ptr.h"
#include "slang.h"
#include "metal-api.h"

#include <vector>

using Slang::ComPtr;

static const ExampleResources resourceBase("hello-world-metal");

struct HelloWorldMetalExample : public TestBase
{
    // Metal API wrapper
    MetalAPI metalAPI;

    const size_t inputElementCount = 16;
    const size_t bufferSize = sizeof(float) * inputElementCount;

    // Initializes the Metal device and command queue
    int initMetalDevice();

    // This function contains the most interesting part of this example.
    // It loads the `hello-world.slang` shader and compiles it using the Slang API
    // into Metal Shading Language, then creates a Metal compute pipeline from the compiled shader.
    int createComputePipelineFromShader();

    // Creates the input and output buffers and uploads initial data
    int createInOutBuffers();

    // Dispatches the compute task
    int dispatchCompute();

    // Reads back and prints the result of the compute task
    int printComputeResults();

    // Main logic of this example
    int run();

    ~HelloWorldMetalExample();
};

int exampleMain(int argc, char** argv)
{
    HelloWorldMetalExample example;
    example.parseOption(argc, argv);
    return example.run();
}

/************************************************************/
/* HelloWorldMetalExample Implementation */
/************************************************************/

int HelloWorldMetalExample::run()
{
    // If Metal failed to initialize, skip running but return success anyway.
    // This allows our automated testing to distinguish between essential failures and the
    // case where the application is just not supported.
    if (int result = initMetalDevice())
        return (metalAPI.device == nullptr) ? 0 : result;
    RETURN_ON_FAIL(createComputePipelineFromShader());
    RETURN_ON_FAIL(createInOutBuffers());
    RETURN_ON_FAIL(dispatchCompute());
    RETURN_ON_FAIL(printComputeResults());
    return 0;
}

int HelloWorldMetalExample::initMetalDevice()
{
    if (metalAPI.initDevice() != 0)
    {
        printf("Failed to initialize Metal device.\n");
        return -1;
    }
    return 0;
}

int HelloWorldMetalExample::createComputePipelineFromShader()
{
    // First we need to create slang global session to work with the Slang API.
    ComPtr<slang::IGlobalSession> slangGlobalSession;
    RETURN_ON_FAIL(slang::createGlobalSession(slangGlobalSession.writeRef()));

    // Next we create a compilation session to generate Metal code from Slang source.
    slang::SessionDesc sessionDesc = {};
    slang::TargetDesc targetDesc = {};
    targetDesc.format = SLANG_METAL;
    targetDesc.profile = slangGlobalSession->findProfile("metal2.3");
    targetDesc.flags = 0;

    sessionDesc.targets = &targetDesc;
    sessionDesc.targetCount = 1;
    sessionDesc.compilerOptionEntryCount = 0;

    ComPtr<slang::ISession> session;
    RETURN_ON_FAIL(slangGlobalSession->createSession(sessionDesc, session.writeRef()));

    // Once the session has been obtained, we can start loading code into it.
    //
    // The simplest way to load code is by calling `loadModule` with the name of a Slang
    // module. A call to `loadModule("hello-world")` will behave more or less as if you
    // wrote:
    //
    //      import hello_world;
    //
    // In a Slang shader file. The compiler will use its search paths to try to locate
    // `hello-world.slang`, then compile and load that file. If a matching module had
    // already been loaded previously, that would be used directly.
    slang::IModule* slangModule = nullptr;
    {
        ComPtr<slang::IBlob> diagnosticBlob;
        Slang::String path = resourceBase.resolveResource("hello-world.slang");
        slangModule = session->loadModule(path.getBuffer(), diagnosticBlob.writeRef());
        diagnoseIfNeeded(diagnosticBlob);
        if (!slangModule)
            return -1;
    }

    // Loading the `hello-world` module will compile and check all the shader code in it,
    // including the shader entry points we want to use. Now that the module is loaded
    // we can look up those entry points by name.
    //
    // Note: If you are using this `loadModule` approach to load your shader code it is
    // important to tag your entry point functions with the `[shader("...")]` attribute
    // (e.g., `[shader("compute")] void computeMain(...)`). Without that information there
    // is no unambiguous way for the compiler to know which functions represent entry
    // points when it parses your code via `loadModule()`.
    //
    ComPtr<slang::IEntryPoint> entryPoint;
    slangModule->findEntryPointByName("computeMain", entryPoint.writeRef());

    // At this point we have a few different Slang API objects that represent
    // pieces of our code: `module` and `entryPoint`.
    //
    // A single Slang module could contain many different entry points (e.g.,
    // four vertex entry points, three fragment entry points, and two compute
    // shaders), and before we try to generate output code for our target API
    // we need to identify which entry points we plan to use together.
    //
    // Modules and entry points are both examples of *component types* in the
    // Slang API. The API also provides a way to build a *composite* out of
    // other pieces, and that is what we are going to do with our module
    // and entry points.
    //
    Slang::List<slang::IComponentType*> componentTypes;
    componentTypes.add(slangModule);
    componentTypes.add(entryPoint);

    // Actually creating the composite component type is a single operation
    // on the Slang session, but the operation could potentially fail if
    // something about the composite was invalid (e.g., you are trying to
    // combine multiple copies of the same module), so we need to deal
    // with the possibility of diagnostic output.
    //
    ComPtr<slang::IComponentType> composedProgram;
    {
        ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = session->createCompositeComponentType(
            componentTypes.getBuffer(),
            componentTypes.getCount(),
            composedProgram.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        RETURN_ON_FAIL(result);
    }

    // Now we can call `composedProgram->getEntryPointCode()` to retrieve the
    // compiled Metal Shading Language code that we will use to create a Metal compute pipeline.
    // This will trigger the final Slang compilation and Metal code generation.
    ComPtr<slang::IBlob> metalCode;
    {
        ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = composedProgram->getEntryPointCode(
            0,
            0,
            metalCode.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        RETURN_ON_FAIL(result);

        if (isTestMode())
        {
            printEntrypointHashes(1, 1, composedProgram);
        }
    }

    // Create Metal compute pipeline from the compiled shader code
    RETURN_ON_FAIL(metalAPI.createComputePipeline(
        metalCode->getBufferPointer(),
        metalCode->getBufferSize()));

    return 0;
}

int HelloWorldMetalExample::createInOutBuffers()
{
    // Create input and output buffers
    RETURN_ON_FAIL(metalAPI.createBuffers(bufferSize));

    // Prepare initial input data
    std::vector<float> inputData(inputElementCount);
    for (size_t i = 0; i < inputElementCount; i++)
        inputData[i] = static_cast<float>(i);

    // Upload data to input buffers (buffer 0 and buffer 1 get the same data)
    RETURN_ON_FAIL(metalAPI.uploadData(0, inputData.data(), bufferSize));
    RETURN_ON_FAIL(metalAPI.uploadData(1, inputData.data(), bufferSize));

    return 0;
}

int HelloWorldMetalExample::dispatchCompute()
{
    // Dispatch the compute shader
    RETURN_ON_FAIL(metalAPI.dispatchCompute(inputElementCount));
    return 0;
}

int HelloWorldMetalExample::printComputeResults()
{
    // Download results from output buffer (buffer 2)
    std::vector<float> outputData(inputElementCount);
    RETURN_ON_FAIL(metalAPI.downloadData(2, outputData.data(), bufferSize));

    // Print results
    for (size_t i = 0; i < inputElementCount; i++)
    {
        printf("%f\n", outputData[i]);
    }

    return 0;
}

HelloWorldMetalExample::~HelloWorldMetalExample()
{
    // Metal API cleanup is handled in MetalAPI destructor
}

