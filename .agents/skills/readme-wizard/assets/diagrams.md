# Mermaid Diagram Templates

Use these as starting points when a project has multiple components or a clear data flow. Skip diagrams entirely for simple projects (single libraries, small CLIs, docs-only repos).

## API / Web App

```mermaid
graph LR
    Client[Client] --> API[API Server]
    API --> DB[(Database)]
    API --> Cache[(Cache)]
    API --> Queue[Message Queue]
    Queue --> Worker[Worker]
```

## Monorepo

```mermaid
graph TD
    Root[Monorepo Root]
    Root --> PackageA[packages/core]
    Root --> PackageB[packages/cli]
    Root --> PackageC[packages/web]
    PackageB --> PackageA
    PackageC --> PackageA
```

## Content Pipeline

```mermaid
graph LR
    Source[Content Source] --> Process[Build/Transform]
    Process --> Output[Output]
    Output --> Deploy[Deploy/Publish]
```

## CLI Tool

```mermaid
graph LR
    Input[User Input] --> Parser[Arg Parser]
    Parser --> Command[Command Handler]
    Command --> Output[Output]
    Command --> FS[File System]
```

## Plugin Architecture

```mermaid
graph TD
    Core[Core Engine]
    Core --> PluginA[Plugin A]
    Core --> PluginB[Plugin B]
    Core --> PluginC[Plugin C]
    PluginA --> API[Shared API]
    PluginB --> API
    PluginC --> API
```

---

Generate the diagram from the project's actual structure — adapt these templates, don't use them as-is.
