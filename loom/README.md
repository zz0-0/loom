# Loom

A modern, cross-platform text editor and knowledge base application built with Flutter and Rust, designed for efficient document management and editing with a focus on the custom Blox markup language.

## 🌟 **Overview**

Loom is a sophisticated desktop application that combines the power of Flutter's cross-platform UI framework with Rust's performance for native operations. It provides a VS Code-like editing experience with specialized support for Blox documents - a custom markup language for structured knowledge management.

### 🎯 **Key Features**

#### **Core Editing Capabilities**
- **Multi-language Syntax Highlighting**: Support for Blox, Dart, JavaScript, Python, Rust, and more
- **Advanced Text Editor**: Line numbers, syntax highlighting, find/replace with regex
- **Multi-tab Interface**: Efficient document management with tabbed editing and drag-to-reorder functionality
- **Keyboard Shortcuts**: Full shortcut support (Ctrl+Z/Y, Ctrl+C/V/X, Ctrl+A, Ctrl+S)
- **Code Folding**: Expandable/collapsible code sections with visual indicators
- **Undo/Redo System**: Complete edit history with keyboard and toolbar controls

#### **Blox Language Support**
- **Native Parser**: High-performance Rust-based Blox document parsing
- **Real-time Validation**: Instant syntax checking with error reporting
- **Format Conversion**: Export to HTML, Markdown, JSON, and PDF
- **Rich Content**: Support for structured blocks, metadata, and custom formatting

#### **Workspace Management**
- **File Explorer**: Dual-view system with filesystem and collections
- **Global Search**: Workspace-wide search with regex support
- **File Operations**: Create, delete, rename with enhanced dialogs
- **Directory Navigation**: Tree-based browser with filtering capabilities

#### **Cross-Platform Experience**
- **Desktop First**: Optimized for Windows, macOS, and Linux
- **Adaptive UI**: Responsive design that scales across screen sizes
- **Theme Support**: Light/dark mode with system preference detection
- **Modern Design**: Material 3 design system with custom theming

## 🏗️ **Architecture**

### **Clean Architecture Pattern**
```
Presentation Layer (Flutter/Dart)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (Repositories)
    ↓
Infrastructure Layer (Rust/File System)
```

### **Technology Stack**
- **Frontend**: Flutter (Dart) with Riverpod state management
- **Backend**: Rust for performance-critical operations
- **Integration**: flutter_rust_bridge for seamless Dart-Rust interop
- **UI Framework**: Material 3 with adaptive components
- **Build System**: Flutter's multi-platform build pipeline

### **Key Components**
- **Text Editor**: Custom-built editor with syntax highlighting
- **File System**: Platform-abstracted file operations
- **Blox Parser**: Rust-native document processing
- **UI Registry**: Extensible plugin-based component system
- **State Management**: Reactive state with Riverpod

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK (2.0+)
- Rust toolchain (1.70+)
- VS Code with Flutter and Rust extensions
- Dev container support (recommended)

### **Installation**
```bash
# Clone the repository
git clone <repository-url>
cd loom

# Install Flutter dependencies
flutter pub get

# Build Rust components
cd rust && cargo build

# Run the application
flutter run
```

### **Development Setup**
1. Open in VS Code
2. Use the provided dev container for consistent environment
3. Install recommended extensions (Flutter, Rust Analyzer)
4. Run `flutter pub get` to install dependencies
5. Execute `flutter run` to start development

## 📁 **Project Structure**
```
loom/
├── lib/                    # Flutter application code
│   ├── app/               # Application layer
│   ├── core/              # Core business logic
│   ├── features/          # Feature modules
│   └── shared/            # Shared utilities
├── rust/                  # Rust native code
│   ├── src/              # Rust source files
│   └── Cargo.toml        # Rust dependencies
├── test/                  # Test suites
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── linux/                 # Linux platform code
├── macos/                 # macOS platform code
└── windows/               # Windows platform code
```

## 🔧 **Development**

### **Available Scripts**
```bash
# Run tests
flutter test

# Run integration tests
flutter drive --target=test_driver/integration_test.dart

# Build for production
flutter build linux
flutter build windows
flutter build macos

# Generate Rust bindings
flutter_rust_bridge_codegen generate
```

### **Code Quality**
- **Linting**: `flutter analyze`
- **Formatting**: `dart format .`
- **Testing**: Comprehensive unit and integration tests
- **Documentation**: API documentation with dartdoc

## 🌐 **Cross-Platform Support**

Loom is designed to run on multiple platforms with native performance:

- **Linux**: Primary desktop target with full feature support
- **Windows**: Complete Windows support with native integrations
- **macOS**: Full macOS experience with system integration
- **Web**: Browser-based version (planned)
- **Mobile**: Android/iOS support (future consideration)

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Workflow**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📊 **Project Status**

### **Current Implementation**
- ✅ Core architecture (Clean Architecture + MVVM)
- ✅ Basic text editing with syntax highlighting
- ✅ Blox language parser and validation
- ✅ Multi-tab document management with drag-to-reorder functionality
- ✅ File system operations
- ✅ Cross-platform desktop support
- ✅ Theme system and adaptive UI
- ✅ Find/replace with regex support
- ✅ Global search functionality
- ✅ Export system (PDF, HTML, Markdown)
- ✅ Undo/Redo with keyboard shortcuts
- ✅ Clipboard operations
- ✅ Code folding

### **Roadmap**
- 🔄 Comprehensive test suite (>80% coverage)
- 🔄 CI/CD pipeline with automated testing
- 🔄 Plugin/extension system
- 🔄 Version control integration
- 🔄 Collaboration features
- 🔄 Advanced editor features (multiple cursors, minimap)

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing cross-platform framework
- Rust community for the performance and safety
- flutter_rust_bridge for seamless language interop
- Material Design team for the design system


