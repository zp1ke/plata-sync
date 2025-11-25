import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plata_sync/core/utils/color_extensions.dart';

void main() {
  group('ColorExtensions.fromHex', () {
    test('should parse hex color with # prefix and 6 characters', () {
      final color = ColorExtensions.fromHex('#FF5733');
      expect(color, const Color(0xFFFF5733));
    });

    test('should parse hex color without # prefix and 6 characters', () {
      final color = ColorExtensions.fromHex('FF5733');
      expect(color, const Color(0xFFFF5733));
    });

    test(
      'should parse hex color with # prefix and 8 characters (AARRGGBB)',
      () {
        final color = ColorExtensions.fromHex('#80FF5733');
        expect(color, const Color(0x80FF5733));
      },
    );

    test(
      'should parse hex color without # prefix and 8 characters (AARRGGBB)',
      () {
        final color = ColorExtensions.fromHex('80FF5733');
        expect(color, const Color(0x80FF5733));
      },
    );

    test('should handle lowercase hex values', () {
      final color = ColorExtensions.fromHex('#ff5733');
      expect(color, const Color(0xFFFF5733));
    });

    test('should handle mixed case hex values', () {
      final color = ColorExtensions.fromHex('#Ff5733');
      expect(color, const Color(0xFFFF5733));
    });

    test('should default to full opacity (FF) for 6-character hex', () {
      final color = ColorExtensions.fromHex('FF5733');
      expect((color.a * 255).round(), 255);
      expect((color.r * 255).round(), 255);
      expect((color.g * 255).round(), 87);
      expect((color.b * 255).round(), 51);
    });

    test('should preserve alpha channel for 8-character hex', () {
      final color = ColorExtensions.fromHex('#80FF5733');
      expect((color.a * 255).round(), 128);
      expect((color.r * 255).round(), 255);
      expect((color.g * 255).round(), 87);
      expect((color.b * 255).round(), 51);
    });

    test('should return Colors.grey for invalid hex string', () {
      final color = ColorExtensions.fromHex('invalid');
      expect(color, Colors.grey);
    });

    test('should return Colors.grey for empty string', () {
      final color = ColorExtensions.fromHex('');
      expect(color, Colors.grey);
    });

    test('should return Colors.grey for hex with invalid length', () {
      final color = ColorExtensions.fromHex('#FFF');
      expect(color, Colors.grey);
    });

    test('should return Colors.grey for hex with non-hex characters', () {
      final color = ColorExtensions.fromHex('#GGHHII');
      expect(color, Colors.grey);
    });

    test('should parse black color', () {
      final color = ColorExtensions.fromHex('#000000');
      expect(color, const Color(0xFF000000));
    });

    test('should parse white color', () {
      final color = ColorExtensions.fromHex('#FFFFFF');
      expect(color, const Color(0xFFFFFFFF));
    });
  });
}
