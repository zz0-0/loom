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
- **Responsive Bottom Bar**: Dynamic file information display with cursor position, file type, and document status
- **Minimap**: Scrollable code overview with configurable line numbers display

#### **Blox Language Support**
- **Native Parser**: High-performance Rust-based Blox document parsing
- **Real-time Validation**: Instant syntax checking with error reporting
- **Format Conversion**: Export to HTML, Markdown, JSON, and PDF
- **Rich Content**: Support for structured blocks, metadata, and custom formatting
- **Advanced Inline Elements**: Bold, italic, code, links, strikethrough, highlight, subscript, superscript, math expressions
- **Complex Lists**: Ordered, unordered, task lists with nested support
- **Table Rendering**: Markdown-style tables with headers and data rows
- **Preview Mode**: Live preview of Blox documents with rich formatting
- **Enhanced Editor**: Syntax highlighting with preview toggle for immediate visual feedback

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
- **Code Generation**: Freezed for enhanced data structures and serialization
- **State Management**: Reactive state with Riverpod and flutter_hooks

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

### **Try the Demo**
After installation, open the demo file to see the enhanced Blox features:
```bash
# The demo file is located at:
# demo/enhanced_blox_demo.blox
```
This file showcases all the new advanced features including inline elements, complex lists, and table rendering.

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
│   │   ├── explorer/      # File explorer and workspace management
│   │   ├── export/        # Document export functionality
│   │   ├── search/        # Global search capabilities
│   │   └── settings/      # Application settings
│   └── shared/            # Shared utilities and widgets
│       ├── presentation/  # UI components and theming
│       │   ├── widgets/   # Reusable widgets
│       │   │   ├── blox_renderer.dart    # Rich Blox document rendering
│       │   │   ├── blox_viewer.dart      # Blox document viewer components
│       │   │   └── layouts/              # Layout components
│       │   └── theme/    # Theme and styling
│       └── data/         # Shared data models and providers
├── rust/                  # Rust native code
│   ├── src/
│   │   ├── api/          # Flutter Rust Bridge API
│   │   │   └── blox_api.rs # Blox parsing and conversion API
│   │   ├── blox/         # Blox language implementation
│   │   │   ├── ast.rs    # Abstract Syntax Tree definitions
│   │   │   ├── parser.rs # Blox document parser
│   │   │   ├── encoder.rs # Blox document encoder
│   │   │   └── decoder.rs # Output format conversion
│   │   └── lib.rs        # Main library interface
│   └── Cargo.toml        # Rust dependencies
├── demo/                  # Demo files and examples
│   └── enhanced_blox_demo.blox # Feature demonstration
├── test/                  # Test suites
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── linux/               # Linux platform code
├── macos/               # macOS platform code
└── windows/             # Windows platform code
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

### **Current Implementation Status (Updated: September 2025)**
- ✅ **Core Architecture**: Clean Architecture + MVVM with Riverpod state management
- ✅ **Flutter + Rust Integration**: Complete bidirectional communication via flutter_rust_bridge
- ✅ **Blox Language Support**: Full parser, encoder, decoder with advanced features
- ✅ **Multi-Tab Editor**: Drag-to-reorder tabs with keyboard navigation
- ✅ **File System Integration**: Native file dialogs, workspace management, file tree
- ✅ **Syntax Highlighting**: Multi-language support + custom Blox highlighter
- ✅ **Advanced Editor Features**: Minimap, code folding, undo/redo, clipboard operations
- ✅ **Export System**: PDF, HTML, Markdown, JSON, Plain Text formats
- ✅ **UI/UX Polish**: Material 3, adaptive themes, animations, responsive design
- ✅ **Plugin Architecture**: Extensible plugin system with APIs for commands, UI, settings
- ✅ **Cross-Platform**: Windows, macOS, Linux with platform-specific adaptations
- ✅ **Settings System**: Comprehensive preferences with theme customization
- ✅ **Collection Management**: Smart categorization with 9 predefined templates

### **Production Readiness Gaps**
- ❌ **Testing Coverage**: Minimal (~10% coverage, basic test setup only)
- ❌ **CI/CD Pipeline**: No automated testing or deployment
- ❌ **Security**: Basic measures, no encryption or secure storage
- ❌ **Performance Monitoring**: No metrics or profiling systems
- ❌ **Advanced Features**: Multiple cursors, Git integration, collaboration missing

### **Recent Enhancements (September 2025)**
- ✅ **Enhanced Minimap**: Configurable line numbers with syntax highlighting
- ✅ **App Animations System**: Centralized micro-interactions framework
- ✅ **Collection Templates**: 9 predefined templates with smart categorization
- ✅ **Keyboard Shortcuts**: Centralized service with conflict detection
- ✅ **Theme Customization**: Color picker, presets, font selection
- ✅ **File Tree Enhancements**: Search, context menus, drag-and-drop
- ✅ **Export Dialog**: Complete UI with format options and file selection

## 🎉 **Recent Enhancements (v1.0)**

### **Advanced Blox Language Features**
Loom now supports comprehensive Blox document formatting with rich inline elements and complex structures:

#### **Inline Elements**
- **Text Formatting**: `**bold**`, `*italic*`, `~~strikethrough~~`, `==highlight==`
- **Code & Math**: `` `code` ``, `$math expressions$`
- **Links & References**: `[text](url)`, `@references`
- **Sub/Superscript**: `H₂O`, `E=mc²`

#### **Advanced Lists**
- **Ordered Lists**: `1. First item`, `2. Second item`
- **Unordered Lists**: `- Item`, `* Alternative bullet`
- **Task Lists**: `- [ ] Unchecked`, `- [x] Checked`
- **Nested Lists**: Proper indentation and hierarchy support

#### **Table Support**
- **Markdown Tables**: 
  ```markdown
  | Name | Age | City |
  |------|-----|------|
  | John | 25  | NYC  |
  ```
- **Header Support**: Automatic header detection and styling
- **Responsive Design**: Tables adapt to content and screen size

#### **Preview Mode**
- **Live Preview**: Toggle between edit and preview modes
- **Rich Rendering**: Full visual representation of Blox documents
- **Syntax Highlighting**: Enhanced editor with Blox-specific highlighting
- **Real-time Updates**: Instant preview as you type

### **Technical Improvements**
- **Enhanced Rust Parser**: Complete rewrite with advanced feature support
- **Flutter Integration**: Seamless Rust-Flutter data conversion
- **Performance Optimization**: Efficient rendering of complex documents
- **Memory Management**: Optimized for large document handling

### **UI/UX Enhancements**
- **Responsive Bottom Bar**: Dynamic display of file information, cursor position, and document status
- **Minimap Improvements**: Enhanced minimap with configurable line numbers display
- **ScrollController Optimization**: Fixed multiple controller attachment issues for smooth scrolling
- **Enhanced File Type Display**: Moved file type information from main toolbar to responsive bottom bar

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing cross-platform framework
- Rust community for the performance and safety
- flutter_rust_bridge for seamless language interop
- Material Design team for the design system

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
- **Code Generation**: Freezed for enhanced data structures and serialization
- **State Management**: Reactive state with Riverpod and flutter_hooks

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

### **Try the Demo**
After installation, open the demo file to see the enhanced Blox features:
```bash
# The demo file is located at:
# demo/enhanced_blox_demo.blox
```
This file showcases all the new advanced features including inline elements, complex lists, and table rendering.

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
│   │   ├── explorer/      # File explorer and workspace management
│   │   ├── export/        # Document export functionality
│   │   ├── search/        # Global search capabilities
│   │   └── settings/      # Application settings
│   └── shared/            # Shared utilities and widgets
│       ├── presentation/  # UI components and theming
│       │   ├── widgets/   # Reusable widgets
│       │   │   ├── blox_renderer.dart    # Rich Blox document rendering
│       │   │   ├── blox_viewer.dart      # Blox document viewer components
│       │   │   └── layouts/              # Layout components
│       │   └── theme/    # Theme and styling
│       └── data/         # Shared data models and providers
├── rust/                  # Rust native code
│   ├── src/
│   │   ├── api/          # Flutter Rust Bridge API
│   │   │   └── blox_api.rs # Blox parsing and conversion API
│   │   ├── blox/         # Blox language implementation
│   │   │   ├── ast.rs    # Abstract Syntax Tree definitions
│   │   │   ├── parser.rs # Blox document parser
│   │   │   ├── encoder.rs # Blox document encoder
│   │   │   └── decoder.rs # Output format conversion
│   │   └── lib.rs        # Main library interface
│   └── Cargo.toml        # Rust dependencies
├── demo/                  # Demo files and examples
│   └── enhanced_blox_demo.blox # Feature demonstration
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
- ✅ **Advanced Blox Features**: Inline elements, lists, tables with rich rendering
- ✅ **Preview Mode**: Live document preview with enhanced BloxRenderer
- ✅ **Enhanced UI Components**: BloxViewer, BloxDocumentViewer widgets
- ✅ **Rust-Flutter Integration**: Complete bidirectional data conversion

### **Roadmap**
- 🔄 Comprehensive test suite (>80% coverage)
- 🔄 CI/CD pipeline with automated testing
- 🔄 Plugin/extension system
- 🔄 Version control integration
- 🔄 Collaboration features
- 🔄 Advanced editor features (multiple cursors, minimap)
- 🔄 Web platform support
- 🔄 Mobile app development
- 🔄 AI-powered content suggestions
- 🔄 Advanced Blox features (custom blocks, templates)

## 🎉 **Recent Enhancements (v1.0)**

### **Advanced Blox Language Features**
Loom now supports comprehensive Blox document formatting with rich inline elements and complex structures:

#### **Inline Elements**
- **Text Formatting**: `**bold**`, `*italic*`, `~~strikethrough~~`, `==highlight==`
- **Code & Math**: `` `code` ``, `$math expressions$`
- **Links & References**: `[text](url)`, `@references`
- **Sub/Superscript**: `H₂O`, `E=mc²`

#### **Advanced Lists**
- **Ordered Lists**: `1. First item`, `2. Second item`
- **Unordered Lists**: `- Item`, `* Alternative bullet`
- **Task Lists**: `- [ ] Unchecked`, `- [x] Checked`
- **Nested Lists**: Proper indentation and hierarchy support

#### **Table Support**
- **Markdown Tables**: 
  ```markdown
  | Name | Age | City |
  |------|-----|------|
  | John | 25  | NYC  |
  ```
- **Header Support**: Automatic header detection and styling
- **Responsive Design**: Tables adapt to content and screen size

#### **Preview Mode**
- **Live Preview**: Toggle between edit and preview modes
- **Rich Rendering**: Full visual representation of Blox documents
- **Syntax Highlighting**: Enhanced editor with Blox-specific highlighting
- **Real-time Updates**: Instant preview as you type

### **Technical Improvements**
- **Enhanced Rust Parser**: Complete rewrite with advanced feature support
- **Flutter Integration**: Seamless Rust-Flutter data conversion
- **Performance Optimization**: Efficient rendering of complex documents
- **Memory Management**: Optimized for large document handling

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing cross-platform framework
- Rust community for the performance and safety
- flutter_rust_bridge for seamless language interop
- Material Design team for the design system


