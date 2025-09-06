# Loom Development Environment

## Why Dev Container?

This project uses a development container to ensure a consistent and reproducible development environment across all contributors and deployment targets. The dev container provides several key benefits:

### 🚀 **Pre-configured Environment**
- **Flutter SDK**: Latest stable Flutter version pre-installed and configured
- **Rust Toolchain**: Complete Rust development environment with Cargo and rustc
- **Dart SDK**: Automatically available alongside Flutter
- **Build Tools**: All necessary build tools and dependencies for cross-platform development

### 🔧 **Cross-Platform Consistency**
- **Linux Base**: Debian-based container ensuring consistent behavior across Windows, macOS, and Linux hosts
- **Isolated Environment**: Dependencies and tools isolated from host system
- **Version Pinning**: Exact versions of all tools and dependencies locked for reproducibility

### 🛠️ **Integrated Tooling**
- **VS Code Extensions**: Rust language support and Flutter extensions pre-configured
- **PATH Setup**: All tools (flutter, rustc, cargo, dart) available on PATH
- **Hot Reload**: Full Flutter development workflow with hot reload support

### 📦 **Dependency Management**
- **flutter_rust_bridge**: Pre-configured for Dart-Rust interop
- **Native Libraries**: System dependencies for Rust compilation
- **Android/iOS Tools**: SDKs and build tools for mobile development
- **Web Tools**: Chrome and web development dependencies

### 🔒 **Security & Isolation**
- **Containerized**: Development environment isolated from host system
- **Clean State**: Fresh environment for each development session
- **Dependency Isolation**: No conflicts with host system packages

### 🚀 **Getting Started**
1. Ensure you have VS Code and the Dev Containers extension installed
2. Clone the repository
3. Open in VS Code: `code .`
4. When prompted, click "Reopen in Container" or use Command Palette: `Dev Containers: Reopen in Container`
5. The environment will build automatically with all dependencies

### 📋 **Container Configuration**
- **Base Image**: `ghcr.io/thephaseless/devcontainers/flutter:latest`
- **Rust Features**: `ghcr.io/devcontainers/features/rust:1`
- **Platform Support**: Linux (Debian bookworm)
- **Architecture**: Supports x86_64 and ARM64

This setup ensures that all developers work in the exact same environment, eliminating "works on my machine" issues and streamlining the onboarding process for new contributors.
