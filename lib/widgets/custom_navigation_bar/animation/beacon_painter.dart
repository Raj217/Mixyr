// Copyright (c) 2020 Ricky Wen
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flutter/material.dart';

class BeaconPainter extends CustomPainter {
  final double? beaconRadius;
  final Color? color;
  final double? maxRadius;
  final Offset? offset;

  const BeaconPainter({
    this.beaconRadius,
    this.color,
    this.maxRadius,
    this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (beaconRadius == maxRadius) return;

    if (beaconRadius! < maxRadius! * 0.5) {
      final Paint paint = Paint()..color = color!;
      canvas.drawCircle(offset!, beaconRadius!, paint);
    } else {
      final Paint paint = Paint()
        ..color = color!
        ..style = PaintingStyle.stroke
        ..strokeWidth = maxRadius! - beaconRadius!;
      canvas.drawCircle(offset!, beaconRadius!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
