#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <optional>
#include <slang-com-ptr.h>
#include <slang-rhi.h>
#include <slang-rhi/shader-cursor.h>
#include <slang.h>
#include <string>
#include <vector>

using Slang::ComPtr;
using namespace rhi;

namespace
{

// The demo reserves one explicit slot for the hidden coverage buffer.
// Slang injects the resource during instrumentation, but the host still
// decides where that hidden resource should bind.
constexpr uint32_t kCoverageBinding = 11;
constexpr uint32_t kCoverageSpace = 3;

// Normal shader output: the compute shader writes one uint per input item.
constexpr uint32_t kItemCount = 100000;
constexpr uint32_t kThreadsPerGroup = 64;

enum class DemoBackend
{
    Vulkan,
    CUDA,
};

enum class RunResult
{
    Succeeded,
    Skipped,
};

[[noreturn]] void fail(const std::string& message)
{
    std::cerr << "error: " << message << "\n";
    std::exit(1);
}

void check(Result result, const char* what)
{
    if (SLANG_FAILED(result))
        fail(std::string(what) + " failed");
}

void checkSlang(SlangResult result, const char* what)
{
    if (SLANG_FAILED(result))
        fail(std::string(what) + " failed");
}

void diagnoseIfNeeded(slang::IBlob* diagnostics)
{
    if (diagnostics && diagnostics->getBufferSize())
    {
        std::cerr.write(
            reinterpret_cast<const char*>(diagnostics->getBufferPointer()),
            diagnostics->getBufferSize());
        std::cerr << "\n";
    }
}

uint32_t scaleByFactorHost(uint32_t value, uint32_t factor)
{
    if (factor == 0)
        return 0;
    return value * factor;
}

uint32_t clampToRangeHost(uint32_t value, uint32_t maxValue)
{
    return value > maxValue ? maxValue : value;
}

uint32_t softenBurstHost(uint32_t value, uint32_t lane)
{
    uint32_t softened = value;
    const uint32_t burstBucket = lane % 4u;

    if (burstBucket == 0u)
        softened += 13u;
    else if (burstBucket == 1u)
        softened += 3u;
    else if (burstBucket == 2u)
        softened += lane % 9u;
    else
        softened += lane % 5u;

    if ((lane % 13u) == 0u)
        softened += 29u;

    return softened;
}

uint32_t integrateMotionHost(uint32_t x, uint32_t frame)
{
    const uint32_t scaled = scaleByFactorHost(x + 1u, (frame % 5u) + 1u);
    uint32_t adjusted = scaled;

    if ((x % 11u) == 0u)
        adjusted += 19u;
    else if ((x % 7u) == 0u)
        adjusted += 7u;
    else if ((x % 3u) == 0u)
        adjusted += 3u;

    return softenBurstHost(adjusted, x);
}

uint32_t applyMaterialHost(uint32_t value, uint32_t lane)
{
    uint32_t shaded = value;

    if ((lane & 1u) == 0u)
        shaded += 2u;
    else
        shaded += 1u;

    const uint32_t materialBucket = lane % 5u;
    if (materialBucket == 0u)
        shaded /= 2u + (lane % 3u);
    else if (materialBucket == 1u)
        shaded += 5u;
    else if (materialBucket == 2u)
        shaded += 11u;
    else if (materialBucket == 3u)
        shaded += 17u;
    else
        shaded += 23u;

    return clampToRangeHost(shaded, 400000u);
}

uint32_t finalizeEnergyHost(uint32_t value, uint32_t lane)
{
    uint32_t finalized = value;

    if ((lane % 8u) == 0u)
        finalized += 31u;
    else if ((lane % 8u) < 3u)
        finalized += 9u;
    else
        finalized += 4u;

    if ((lane % 10u) == 0u)
        finalized /= 2u;
    else if ((lane % 9u) == 0u)
        finalized += 27u;

    return clampToRangeHost(finalized, 500000u);
}

uint32_t computeExpectedOutput(uint32_t itemIndex)
{
    const uint32_t integrated = integrateMotionHost(itemIndex, 17u);
    const uint32_t material = applyMaterialHost(integrated, itemIndex);
    return finalizeEnergyHost(material, itemIndex);
}

struct SyntheticCoverageProgram
{
    // Normal runtime object used to create pipelines and shader objects.
    ComPtr<IShaderProgram> program;

    // Coverage-specific metadata returned by Slang for the linked entry point.
    ComPtr<slang::IMetadata> metadata;

    // Coverage semantics: counter count, slot-to-source mapping, manifest data.
    slang::ICoverageTracingMetadata* coverageMetadata = nullptr;

    // Hidden resource binding contract: where the synthesized coverage buffer
    // must be bound for the selected backend.
    slang::ISyntheticResourceMetadata* syntheticMetadata = nullptr;

    // `slang-rhi` view of the hidden resources copied from Slang metadata.
    std::vector<SyntheticResourceBindingDesc> syntheticResources;
};

std::filesystem::path getDemoDirectory()
{
    return std::filesystem::path(__FILE__).parent_path();
}

const std::string& getDemoSearchPath()
{
    static const std::string path = getDemoDirectory().string();
    return path;
}

std::filesystem::path getOutputDirectory()
{
    return std::filesystem::current_path();
}

const char* getBackendName(DemoBackend backend)
{
    switch (backend)
    {
    case DemoBackend::Vulkan:
        return "vulkan";
    case DemoBackend::CUDA:
        return "cuda";
    default:
        fail("unhandled backend");
    }
}

DeviceType getDeviceType(DemoBackend backend)
{
    switch (backend)
    {
    case DemoBackend::Vulkan:
        return DeviceType::Vulkan;
    case DemoBackend::CUDA:
        return DeviceType::CUDA;
    default:
        fail("unhandled backend");
    }
}

bool isBackendAvailable(DemoBackend backend)
{
    return getRHI()->getAdapters(getDeviceType(backend)).getCount() != 0;
}

SyntheticResourceScope mapScope(slang::SyntheticResourceScope scope)
{
    switch (scope)
    {
    case slang::SyntheticResourceScope::Global:
        return SyntheticResourceScope::Global;
    case slang::SyntheticResourceScope::EntryPoint:
        return SyntheticResourceScope::EntryPoint;
    default:
        fail("unhandled synthetic resource scope");
    }
}

SyntheticResourceAccess mapAccess(slang::SyntheticResourceAccess access)
{
    switch (access)
    {
    case slang::SyntheticResourceAccess::Read:
        return SyntheticResourceAccess::Read;
    case slang::SyntheticResourceAccess::Write:
        return SyntheticResourceAccess::Write;
    case slang::SyntheticResourceAccess::ReadWrite:
        return SyntheticResourceAccess::ReadWrite;
    default:
        fail("unhandled synthetic resource access");
    }
}

ComPtr<IDevice> createDeviceForBackend(
    DemoBackend backend,
    ComPtr<slang::IGlobalSession>& outGlobalSession)
{
    checkSlang(slang::createGlobalSession(outGlobalSession.writeRef()), "createGlobalSession");

    std::vector<slang::CompilerOptionEntry> compilerOptions;
    const char* searchPaths[] = {getDemoSearchPath().c_str()};

    // Coverage instrumentation starts here. These options do not affect the
    // shader's functional output; they tell Slang to inject hidden counters
    // and to report how the host should bind the hidden counter buffer.
    slang::CompilerOptionEntry traceCoverage = {};
    traceCoverage.name = slang::CompilerOptionName::TraceCoverage;
    traceCoverage.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverage.value.intValue0 = 1;
    compilerOptions.push_back(traceCoverage);

    slang::CompilerOptionEntry traceCoverageBinding = {};
    traceCoverageBinding.name = slang::CompilerOptionName::TraceCoverageBinding;
    traceCoverageBinding.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverageBinding.value.intValue0 = kCoverageBinding;
    traceCoverageBinding.value.intValue1 = kCoverageSpace;
    compilerOptions.push_back(traceCoverageBinding);

    if (backend == DemoBackend::Vulkan)
    {
        // This is backend setup, not coverage logic. Vulkan in this demo uses
        // the direct SPIR-V path to match the `slang-rhi` Vulkan integration.
        slang::CompilerOptionEntry emitSpirvDirectly = {};
        emitSpirvDirectly.name = slang::CompilerOptionName::EmitSpirvDirectly;
        emitSpirvDirectly.value.kind = slang::CompilerOptionValueKind::Int;
        emitSpirvDirectly.value.intValue0 = 1;
        compilerOptions.push_back(emitSpirvDirectly);
    }

    DeviceDesc desc = {};
    desc.deviceType = getDeviceType(backend);
    desc.slang.slangGlobalSession = outGlobalSession;
    desc.slang.searchPaths = searchPaths;
    desc.slang.searchPathCount = 1;
    desc.slang.compilerOptionEntries = compilerOptions.data();
    desc.slang.compilerOptionEntryCount = (uint32_t)compilerOptions.size();

    ComPtr<IDevice> device;
    const std::string createLabel = std::string("createDevice(") + getBackendName(backend) + ")";
    check(getRHI()->createDevice(desc, device.writeRef()), createLabel.c_str());
    return device;
}

SyntheticCoverageProgram createCoverageProgram(
    IDevice* device,
    slang::IGlobalSession* globalSession,
    DemoBackend backend)
{
    SyntheticCoverageProgram result;

    // Normal target selection. Coverage uses the same shader source and entry
    // point as a non-instrumented build; only the compiler options differ.
    slang::TargetDesc targetDesc = {};
    switch (backend)
    {
    case DemoBackend::Vulkan:
        targetDesc.format = SLANG_SPIRV;
        targetDesc.profile = globalSession->findProfile("spirv_1_5");
        break;
    case DemoBackend::CUDA:
        targetDesc.format = SLANG_PTX;
        targetDesc.profile = globalSession->findProfile("sm_5_0");
        break;
    default:
        fail("unhandled backend");
    }

    std::vector<slang::CompilerOptionEntry> compilerOptions;

    // Coverage instrumentation is enabled again at session/compile time so the
    // linked program carries both counter semantics and hidden binding metadata.
    slang::CompilerOptionEntry traceCoverage = {};
    traceCoverage.name = slang::CompilerOptionName::TraceCoverage;
    traceCoverage.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverage.value.intValue0 = 1;
    compilerOptions.push_back(traceCoverage);

    slang::CompilerOptionEntry traceCoverageBinding = {};
    traceCoverageBinding.name = slang::CompilerOptionName::TraceCoverageBinding;
    traceCoverageBinding.value.kind = slang::CompilerOptionValueKind::Int;
    traceCoverageBinding.value.intValue0 = kCoverageBinding;
    traceCoverageBinding.value.intValue1 = kCoverageSpace;
    compilerOptions.push_back(traceCoverageBinding);

    slang::SessionDesc sessionDesc = {};
    sessionDesc.targets = &targetDesc;
    sessionDesc.targetCount = 1;
    sessionDesc.compilerOptionEntries = compilerOptions.data();
    sessionDesc.compilerOptionEntryCount = (uint32_t)compilerOptions.size();

    ComPtr<slang::ISession> slangSession;
    checkSlang(globalSession->createSession(sessionDesc, slangSession.writeRef()), "createSession");

    // Normal Slang module loading and linking. The demo uses three `.slang`
    // files, but from the host point of view this is the same flow as any
    // ordinary multi-file program.
    ComPtr<slang::IBlob> diagnostics;
    const std::string appPath = (getDemoDirectory() / "app.slang").string();
    slang::IModule* loadedModule =
        slangSession->loadModule(appPath.c_str(), diagnostics.writeRef());
    diagnoseIfNeeded(diagnostics);
    if (!loadedModule)
        fail("loadModule(app.slang) returned null");
    ComPtr<slang::IModule> module(loadedModule);

    std::vector<ComPtr<slang::IComponentType>> components;
    components.push_back(ComPtr<slang::IComponentType>(module.get()));

    ComPtr<slang::IEntryPoint> entryPoint;
    checkSlang(
        module->findEntryPointByName("computeMain", entryPoint.writeRef()),
        "findEntryPointByName");
    if (!entryPoint)
        fail("entry point computeMain not found");
    components.push_back(ComPtr<slang::IComponentType>(entryPoint.get()));

    std::vector<slang::IComponentType*> rawComponents;
    rawComponents.reserve(components.size());
    for (auto& component : components)
        rawComponents.push_back(component.get());

    diagnostics.setNull();
    ComPtr<slang::IComponentType> composedProgram;
    checkSlang(
        slangSession->createCompositeComponentType(
            rawComponents.data(),
            rawComponents.size(),
            composedProgram.writeRef(),
            diagnostics.writeRef()),
        "createCompositeComponentType");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    ComPtr<slang::IComponentType> linkedProgram;
    checkSlang(composedProgram->link(linkedProgram.writeRef(), diagnostics.writeRef()), "link");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    ComPtr<slang::IBlob> entryPointCode;
    checkSlang(
        linkedProgram->getEntryPointCode(0, 0, entryPointCode.writeRef(), diagnostics.writeRef()),
        "getEntryPointCode");
    diagnoseIfNeeded(diagnostics);

    diagnostics.setNull();
    checkSlang(
        linkedProgram
            ->getEntryPointMetadata(0, 0, result.metadata.writeRef(), diagnostics.writeRef()),
        "getEntryPointMetadata");
    diagnoseIfNeeded(diagnostics);

    // Coverage-specific metadata query:
    // - `ICoverageTracingMetadata` tells us what each counter means.
    // - `ISyntheticResourceMetadata` tells us how to bind the hidden buffer.
    result.coverageMetadata = (slang::ICoverageTracingMetadata*)result.metadata->castAs(
        slang::ICoverageTracingMetadata::getTypeGuid());
    result.syntheticMetadata = (slang::ISyntheticResourceMetadata*)result.metadata->castAs(
        slang::ISyntheticResourceMetadata::getTypeGuid());
    if (!result.coverageMetadata || !result.syntheticMetadata)
        fail("expected coverage + synthetic metadata");

    const uint32_t resourceCount = result.syntheticMetadata->getResourceCount();
    result.syntheticResources.reserve(resourceCount);
    for (uint32_t i = 0; i < resourceCount; ++i)
    {
        slang::SyntheticResourceInfo info = {};
        checkSlang(result.syntheticMetadata->getResourceInfo(i, &info), "getResourceInfo");

        // This translation step is the bridge between Slang and `slang-rhi`.
        // Slang describes the hidden resource; `slang-rhi` consumes the same
        // description through `ShaderProgramSyntheticResourcesDesc`.
        SyntheticResourceBindingDesc desc = {};
        desc.id = info.id;
        desc.bindingType = info.bindingType;
        desc.arraySize = info.arraySize;
        desc.scope = mapScope(info.scope);
        desc.access = mapAccess(info.access);
        desc.entryPointIndex = info.entryPointIndex;
        desc.space = info.space;
        desc.binding = info.binding;
        desc.uniformOffset = info.uniformOffset;
        desc.uniformStride = info.uniformStride;
        desc.debugName = info.debugName;
        result.syntheticResources.push_back(desc);
    }

    ShaderProgramSyntheticResourcesDesc syntheticDesc = {};
    syntheticDesc.resources = result.syntheticResources.data();
    syntheticDesc.resourceCount = (uint32_t)result.syntheticResources.size();

    ShaderProgramDesc programDesc = {};
    programDesc.slangGlobalScope = linkedProgram;

    // Coverage-specific extension point: ordinary shader programs would omit
    // `next` here and just pass the linked Slang program.
    programDesc.next = &syntheticDesc;

    diagnostics.setNull();
    check(
        device->createShaderProgram(programDesc, result.program.writeRef(), diagnostics.writeRef()),
        "createShaderProgram");
    diagnoseIfNeeded(diagnostics);

    return result;
}

ComPtr<IBuffer> createBuffer(
    IDevice* device,
    size_t size,
    BufferUsage usage,
    ResourceState defaultState,
    const void* initialData = nullptr)
{
    BufferDesc desc = {};
    desc.size = size;
    desc.format = Format::Undefined;
    desc.elementSize = sizeof(uint32_t);
    desc.usage = usage;
    desc.defaultState = defaultState;
    desc.memoryType = MemoryType::DeviceLocal;

    ComPtr<IBuffer> buffer;
    check(device->createBuffer(desc, initialData, buffer.writeRef()), "createBuffer");
    return buffer;
}

int writeLcovReport(
    slang::ICoverageTracingMetadata* coverage,
    const std::vector<uint32_t>& hits,
    const std::filesystem::path& outputPath)
{
    // Coverage-only reporting helper. This is not needed to execute the shader;
    // it exists solely to turn raw counter values into line-oriented output.
    const uint32_t counterCount = coverage->getCounterCount();
    if (hits.size() != counterCount)
        return -1;

    std::map<std::string, std::map<uint32_t, uint64_t>> byFile;
    for (uint32_t i = 0; i < counterCount; ++i)
    {
        slang::CoverageEntryInfo entry = {};
        if (SLANG_FAILED(coverage->getEntryInfo(i, &entry)))
            continue;
        if (!entry.file || !*entry.file || entry.line == 0)
            continue;
        byFile[entry.file][entry.line] += hits[i];
    }

    std::ofstream file(outputPath, std::ios::binary);
    if (!file)
        return -1;

    file << "TN:shader-coverage-binding-demo\n";
    for (const auto& filePair : byFile)
    {
        file << "SF:" << filePair.first << "\n";
        for (const auto& linePair : filePair.second)
            file << "DA:" << linePair.first << "," << linePair.second << "\n";
        file << "end_of_record\n";
    }
    return 0;
}

std::vector<uint32_t> readUintBuffer(IDevice* device, IBuffer* buffer, size_t count)
{
    ComPtr<ISlangBlob> data;
    check(device->readBuffer(buffer, 0, count * sizeof(uint32_t), data.writeRef()), "readBuffer");
    const auto* ptr = static_cast<const uint32_t*>(data->getBufferPointer());
    return std::vector<uint32_t>(ptr, ptr + count);
}

std::optional<DemoBackend> parseBackendArg(const std::string& value)
{
    if (value == "vulkan")
        return DemoBackend::Vulkan;
    if (value == "cuda")
        return DemoBackend::CUDA;
    return std::nullopt;
}

std::vector<DemoBackend> parseRequestedBackends(int argc, char** argv)
{
    std::vector<DemoBackend> backends = {DemoBackend::Vulkan, DemoBackend::CUDA};
    for (int i = 1; i < argc; ++i)
    {
        const std::string arg = argv[i];
        if (arg.rfind("--device=", 0) == 0)
        {
            const std::string value = arg.substr(std::string("--device=").size());
            if (value == "all")
            {
                backends = {DemoBackend::Vulkan, DemoBackend::CUDA};
                continue;
            }

            auto backend = parseBackendArg(value);
            if (!backend)
                fail("unsupported --device value");
            backends = {*backend};
            continue;
        }

        if (arg == "--help" || arg == "-h")
        {
            std::cout << "usage: shader-coverage-binding-demo [--device=vulkan|cuda|all]\n";
            std::exit(0);
        }

        fail("unknown argument: " + arg);
    }
    return backends;
}

RunResult runDemoForBackend(DemoBackend backend)
{
    const std::string backendName = getBackendName(backend);
    if (!isBackendAvailable(backend))
    {
        std::cout << "skipped: " << backendName << " device not available\n";
        return RunResult::Skipped;
    }

    std::cout << "creating " << backendName << " device\n";
    ComPtr<slang::IGlobalSession> globalSession;
    auto device = createDeviceForBackend(backend, globalSession);

    std::cout << "compiling coverage-enabled shader through slang-rhi for " << backendName << "\n";
    auto program = createCoverageProgram(device.get(), globalSession.get(), backend);
    if (program.syntheticResources.size() != 1)
        fail("expected exactly one synthetic resource");

    // Coverage-specific: the hidden buffer is represented like any other
    // `slang-rhi` resource, but it is not declared in the user-authored source.
    const auto& coverageResource = program.syntheticResources[0];
    std::cout << "synthetic coverage resource: id=" << coverageResource.id
              << " set=" << coverageResource.space << " binding=" << coverageResource.binding
              << " uniformOffset=" << coverageResource.uniformOffset
              << " uniformStride=" << coverageResource.uniformStride << "\n";

    if (backend == DemoBackend::Vulkan)
    {
        // Vulkan/direct-host style query: ask Slang for descriptor-facing
        // `(space, binding)` information for the hidden resource.
        slang::SyntheticResourceDescriptorRange descriptorRange = {};
        checkSlang(
            slang::findSyntheticResourceDescriptorRangeByID(
                program.syntheticMetadata,
                coverageResource.id,
                &descriptorRange),
            "findSyntheticResourceDescriptorRangeByID");
        if (descriptorRange.space != (int32_t)kCoverageSpace ||
            descriptorRange.binding != (int32_t)kCoverageBinding)
            fail("descriptor helper reported unexpected binding");
    }
    else if (backend == DemoBackend::CUDA)
    {
        // CUDA/CPU style query: ask Slang for uniform marshaling layout instead
        // of descriptor coordinates. This is the key difference between the two
        // host families that the new interface needs to support.
        uint32_t coverageIndex = 0;
        checkSlang(
            program.syntheticMetadata->findResourceIndexByID(coverageResource.id, &coverageIndex),
            "findResourceIndexByID");
        slang::SyntheticResourceInfo resourceInfo = {};
        checkSlang(
            program.syntheticMetadata->getResourceInfo(coverageIndex, &resourceInfo),
            "getResourceInfo");
        if (resourceInfo.uniformOffset < 0 || resourceInfo.uniformStride <= 0)
            fail("uniform binding fields unavailable for CUDA");
    }

    // Coverage-specific attribution: once the hidden resource binding is
    // resolved through `ISyntheticResourceMetadata`, `ICoverageTracingMetadata`
    // supplies the counter count and slot-to-source mapping.
    const uint32_t counterCount = program.coverageMetadata->getCounterCount();
    if (counterCount == 0)
        fail("counterCount is zero");

    std::cout << "coverage buffer elements: " << counterCount << "\n";

    ComputePipelineDesc pipelineDesc = {};
    pipelineDesc.program = program.program;
    auto pipeline = device->createComputePipeline(pipelineDesc);
    if (!pipeline)
        fail("createComputePipeline returned null");

    auto rootObject = device->createRootShaderObject(pipeline.get());
    if (!rootObject)
        fail("createRootShaderObject returned null");

    const auto outputDir = getOutputDirectory();
    const std::string outputPrefix = "shader-coverage-binding-demo-" + backendName;
    std::vector<uint32_t> zeroCoverage(counterCount, 0u);
    std::vector<uint32_t> zeroOutput(kItemCount, 0u);

    auto coverageBuffer = createBuffer(
        device.get(),
        zeroCoverage.size() * sizeof(uint32_t),
        BufferUsage::ShaderResource | BufferUsage::UnorderedAccess | BufferUsage::CopySource |
            BufferUsage::CopyDestination,
        ResourceState::UnorderedAccess,
        zeroCoverage.data());
    auto outputBuffer = createBuffer(
        device.get(),
        zeroOutput.size() * sizeof(uint32_t),
        BufferUsage::ShaderResource | BufferUsage::UnorderedAccess | BufferUsage::CopySource |
            BufferUsage::CopyDestination,
        ResourceState::UnorderedAccess,
        zeroOutput.data());

    // Normal shader binding: `outBuffer` is declared in the user shader and is
    // bound through ordinary reflection-driven shader object access.
    ShaderCursor(rootObject.get())["outBuffer"].setBinding(outputBuffer);

    // Coverage-specific binding: the hidden counter buffer is bound through the
    // synthetic resource helper rather than through normal reflection.
    check(
        bindSyntheticResource(
            program.program.get(),
            rootObject.get(),
            coverageResource.id,
            Binding(coverageBuffer)),
        "bindSyntheticResource");

    // Normal dispatch path. Coverage does not require a separate execution API;
    // once the hidden buffer is bound, instrumentation runs as part of the
    // ordinary dispatch.
    auto queue = device->getQueue(QueueType::Graphics);
    auto encoder = queue->createCommandEncoder();
    auto pass = encoder->beginComputePass();
    pass->bindPipeline(pipeline, rootObject);
    pass->dispatchCompute((kItemCount + kThreadsPerGroup - 1) / kThreadsPerGroup, 1, 1);
    pass->end();
    check(queue->submit(encoder->finish()), "queue->submit");
    check(queue->waitOnHost(), "queue->waitOnHost");

    const auto outputValues = readUintBuffer(device.get(), outputBuffer.get(), kItemCount);
    for (uint32_t i = 0; i < kItemCount; ++i)
    {
        const uint32_t expectedValue = computeExpectedOutput(i);
        if (outputValues[i] != expectedValue)
            fail("unexpected compute result");
    }
    std::cout << "output buffer verified for " << kItemCount << " items\n";

    // Coverage-specific readback and interpretation.
    const auto coverageValues = readUintBuffer(device.get(), coverageBuffer.get(), counterCount);
    uint64_t totalHits = 0;
    uint32_t coveredLineCount = 0;
    uint32_t uncoveredLineCount = 0;
    std::map<uint32_t, uint32_t> hitHistogram;
    std::map<std::string, std::map<uint32_t, uint64_t>> byFile;
    for (uint32_t i = 0; i < counterCount; ++i)
    {
        totalHits += coverageValues[i];
        if (coverageValues[i] > 0)
            hitHistogram[coverageValues[i]]++;

        slang::CoverageEntryInfo entry = {};
        checkSlang(program.coverageMetadata->getEntryInfo(i, &entry), "getEntryInfo");
        if (!entry.file || !*entry.file || entry.line == 0)
            continue;
        byFile[entry.file][entry.line] += coverageValues[i];
    }

    bool sawApp = false;
    bool sawPhysics = false;
    bool sawMath = false;

    for (const auto& filePair : byFile)
    {
        const std::string fileName = std::filesystem::path(filePair.first).filename().string();
        if (fileName == "app.slang")
            sawApp = true;
        else if (fileName == "physics.slang")
            sawPhysics = true;
        else if (fileName == "math.slang")
            sawMath = true;

        for (const auto& linePair : filePair.second)
        {
            if (linePair.second > 0)
                ++coveredLineCount;
            else
                ++uncoveredLineCount;
        }
    }

    uint32_t distinctPositiveHitCounts = 0;
    for (const auto& hitPair : hitHistogram)
    {
        if (hitPair.first > 0)
            ++distinctPositiveHitCounts;
    }

    if (totalHits == 0 || coveredLineCount == 0 || uncoveredLineCount == 0)
        fail("coverage counters do not show both covered and uncovered lines");
    if (!(sawApp && sawPhysics && sawMath))
        fail("coverage metadata did not attribute lines across all demo modules");
    if (distinctPositiveHitCounts < 5)
        fail("coverage counters do not show a rich enough hit distribution");

    std::cout << "aggregate coverage hits = " << totalHits << "\n";
    std::cout << "covered lines = " << coveredLineCount
              << ", uncovered lines = " << uncoveredLineCount << "\n";
    std::cout << "distinct positive hit counts = " << distinctPositiveHitCounts << "\n";
    std::cout << "attributed files: " << (sawApp ? "app " : "") << (sawPhysics ? "physics " : "")
              << (sawMath ? "math" : "") << "\n";
    std::cout << "coverage hit histogram:";
    for (const auto& hitPair : hitHistogram)
        std::cout << " [" << hitPair.first << " -> " << hitPair.second << "]";
    std::cout << "\n";

    {
        // Manifest JSON is the structured coverage artifact produced by Slang.
        ComPtr<ISlangBlob> manifestBlob;
        checkSlang(
            slang_writeCoverageManifestJson(program.coverageMetadata, manifestBlob.writeRef()),
            "slang_writeCoverageManifestJson");
        std::ofstream manifest(
            outputDir / (outputPrefix + ".coverage-mapping.json"),
            std::ios::binary);
        manifest.write(
            static_cast<const char*>(manifestBlob->getBufferPointer()),
            (std::streamsize)manifestBlob->getBufferSize());
    }
    // LCOV is a convenience export layered on top of the same counter data.
    if (writeLcovReport(
            program.coverageMetadata,
            coverageValues,
            outputDir / (outputPrefix + ".lcov")) != 0)
    {
        fail("writeLcovReport failed");
    }

    std::cout << "wrote " << (outputDir / (outputPrefix + ".coverage-mapping.json")) << "\n";
    std::cout << "wrote " << (outputDir / (outputPrefix + ".lcov")) << "\n";
    std::cout << backendName << " demo completed successfully\n";
    return RunResult::Succeeded;
}

} // namespace

int main(int argc, char** argv)
{
    // The same demo can exercise both backend families:
    // - Vulkan: hidden resource queried as descriptor coordinates
    // - CUDA: hidden resource queried as uniform marshaling offsets
    auto backends = parseRequestedBackends(argc, argv);
    size_t ranCount = 0;
    for (auto backend : backends)
    {
        if (runDemoForBackend(backend) == RunResult::Succeeded)
            ++ranCount;
    }
    if (ranCount == 0)
        std::cout << "no requested backend was available\n";
    return 0;
}
