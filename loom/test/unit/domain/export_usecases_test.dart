import 'package:flutter_test/flutter_test.dart';
import 'package:loom/features/export/domain/entities/export_entities.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';
import 'package:loom/features/export/domain/usecases/export_usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks
@GenerateMocks([ExportRepository])
import 'export_usecases_test.mocks.dart';

void main() {
  late ExportContentUseCase useCase;
  late MockExportRepository mockRepository;

  setUp(() {
    mockRepository = MockExportRepository();
    useCase = ExportContentUseCase(mockRepository);
  });

  group('ExportContentUseCase Tests', () {
    const testContent = 'Test content for export';
    const testFileName = 'test.txt';
    const testOptions = ExportOptions(
      format: ExportFormat.markdown,
    );

    test('should call repository export method with correct parameters',
        () async {
      // Arrange
      const request = ExportRequest(
        content: testContent,
        fileName: testFileName,
        options: testOptions,
      );

      const expectedResult = ExportResult(
        success: true,
        filePath: '/path/to/exported/file.md',
      );

      when(mockRepository.exportContent(request))
          .thenAnswer((_) async => expectedResult);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedResult));
      verify(mockRepository.exportContent(request)).called(1);
    });

    test('should handle export failure correctly', () async {
      // Arrange
      const request = ExportRequest(
        content: testContent,
        fileName: testFileName,
        options: testOptions,
      );

      const expectedResult = ExportResult(
        success: false,
        filePath: '',
        errorMessage: 'Export failed: Invalid format',
      );

      when(mockRepository.exportContent(any))
          .thenAnswer((_) async => expectedResult);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result.success, isFalse);
      expect(result.errorMessage, equals('Export failed: Invalid format'));
    });

    test('should handle empty content', () async {
      // Arrange
      const emptyContent = '';
      const request = ExportRequest(
        content: emptyContent,
        fileName: testFileName,
        options: testOptions,
      );

      const expectedResult = ExportResult(
        success: true,
        filePath: '/path/to/exported/empty.md',
      );

      when(mockRepository.exportContent(any))
          .thenAnswer((_) async => expectedResult);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result.success, isTrue);
      expect(result.filePath, equals('/path/to/exported/empty.md'));
    });
  });

  group('GetSupportedFormatsUseCase Tests', () {
    late GetSupportedFormatsUseCase getFormatsUseCase;

    setUp(() {
      getFormatsUseCase = GetSupportedFormatsUseCase(mockRepository);
    });

    test('should return list of supported formats', () {
      // Arrange
      final expectedFormats = [
        ExportFormat.pdf,
        ExportFormat.html,
        ExportFormat.markdown,
        ExportFormat.plainText,
      ];

      when(mockRepository.getSupportedFormats()).thenReturn(expectedFormats);

      // Act
      final result = getFormatsUseCase.call();

      // Assert
      expect(result, equals(expectedFormats));
      expect(result.length, equals(4));
      verify(mockRepository.getSupportedFormats()).called(1);
    });
  });

  group('ValidateExportFormatUseCase Tests', () {
    late ValidateExportFormatUseCase validateFormatUseCase;

    setUp(() {
      validateFormatUseCase = ValidateExportFormatUseCase(mockRepository);
    });

    test('should return true for supported format', () {
      // Arrange
      when(mockRepository.isFormatSupported(ExportFormat.markdown))
          .thenReturn(true);

      // Act
      final result = validateFormatUseCase.call(ExportFormat.markdown);

      // Assert
      expect(result, isTrue);
      verify(mockRepository.isFormatSupported(ExportFormat.markdown)).called(1);
    });

    test('should return false for unsupported format', () {
      // Arrange
      when(mockRepository.isFormatSupported(ExportFormat.pdf))
          .thenReturn(false);

      // Act
      final result = validateFormatUseCase.call(ExportFormat.pdf);

      // Assert
      expect(result, isFalse);
      verify(mockRepository.isFormatSupported(ExportFormat.pdf)).called(1);
    });
  });
}
