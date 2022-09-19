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
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animation/beacon_painter.dart';
import 'custom_navigation_bar_item.dart';

class CustomNavigationBar extends StatefulWidget {
  ///
  /// create a [CustomNavigationBar]
  ///
  const CustomNavigationBar(
      {Key? key,
      required this.items,
      this.selectedColor,
      this.unSelectedColor,
      this.onTap,
      this.currentIndex = 0,
      this.iconSize = 24.0,
      this.scaleFactor = 0.2,
      this.elevation = 8.0,
      this.border,
      this.borderRadius = Radius.zero,
      this.backgroundColor,
      this.shadowColor,
      this.strokeColor,
      this.bubbleCurve = Curves.linear,
      this.scaleCurve = Curves.linear,
      this.isFloating = false})
      : assert(scaleFactor <= 0.5, 'Scale factor must smaller than 0.5'),
        assert(scaleFactor > 0, 'Scale factor must bigger than 0'),
        assert(0 <= currentIndex && currentIndex < items.length),
        super(key: key);

  ///
  /// scale factor for the icon scale animation effect.
  /// default is `0.2`.
  final double scaleFactor;

  ///
  /// boolean that control if navigation bar perform floating.
  /// default is false
  ///
  final bool isFloating;

  final Border? border;

  ///
  /// Border radius for navigation bar
  ///
  final Radius borderRadius;

  /// The z-coordinate of this [CustomNavigationBar].
  ///
  /// If null, defaults to `8.0`.
  final double elevation;

  ///
  /// Item data in [CustomNavigationBarItem]
  ///
  final List<CustomNavigationBarItem> items;

  ///
  /// [Color] when [CustomNavigationBarItem] is selected.
  ///
  /// default color is focusColor of Theme.
  final Color? selectedColor;

  ///
  /// [Color] when [CustomNavigationBarItem] is not selected.
  ///
  /// default color is disabledColor of Theme.
  final Color? unSelectedColor;

  ///
  /// callback function when item tapped
  ///
  final Function(int)? onTap;

  ///
  /// current index of navigation bar.
  ///
  final int currentIndex;

  ///
  /// size of icon.
  /// also represent the max radius of bubble effect animation.
  final double iconSize;

  ///
  /// Background color of [CustomNavigationBar]
  ///
  /// Defaults to primaryColor of Theme
  final Color? backgroundColor;

  ///
  /// Shadow color of [CustomNavigationBar]
  ///
  /// Defaults to shadowColor of Theme
  final Color? shadowColor;

  ///
  /// stroke color.
  /// Defaults to focusColor of Theme
  final Color? strokeColor;

  ///
  /// animation curve of bubble effect
  ///
  final Curve bubbleCurve;

  ///
  /// animation curve of scale effect
  ///
  final Curve scaleCurve;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with TickerProviderStateMixin {
  late List<double> _radii;
  late List<double> _sizes;
  AnimationController? _controller;
  AnimationController? _scaleController;

  double _bubbleRadius = 0.0;
  double? _maxRadius;

  double _itemPadding = 0.0;

  @override
  void initState() {
    super.initState();
    _bubbleRadius = 0.0;
    _radii = List<double>.generate(widget.items.length, (index) {
      return _bubbleRadius;
    });

    _sizes = List<double>.generate(widget.items.length, (index) {
      return 0.0;
    });
    _maxRadius = widget.iconSize;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _scaleController?.reverse();
      _startAnimation(widget.currentIndex);
      _startScale(widget.currentIndex);
    }
  }

  void _startAnimation(int index) {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller!,
      curve: widget.bubbleCurve,
    );
    Tween<double>(begin: 0.0, end: 1.0)
        .animate(curvedAnimation)
        .addListener(() {
      setState(() {
        _radii[index] = _maxRadius! * curvedAnimation.value;
      });
    });
    _controller!.forward();
  }

  void _startScale(int index) {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleController?.reverse();
        }
      });
    CurvedAnimation scaleAnimation = CurvedAnimation(
      parent: _scaleController!,
      curve: widget.scaleCurve,
      reverseCurve: widget.scaleCurve.flipped,
    );

    Tween<double>(begin: 0.0, end: 1.0).animate(scaleAnimation).addListener(() {
      setState(() {
        _sizes[index] = scaleAnimation.value * widget.scaleFactor;
      });
    });
    _scaleController!.forward();
  }

  Widget _buildLabel(int index) {
    // unselected
    if (index != widget.currentIndex) {
      if (widget.items[index].title == null && widget.isFloating) {
        return Container();
      } else {
        return widget.items[index].title ?? Container();
      }
    } else {
      //selected
      if (widget.isFloating && widget.items[index].title == null) {
        return Container();
      } else {
        return widget.items[index].selectedTitle ?? Container();
      }
    }
  }

  Widget _buildIcon(int index) {
    return SizedBox(
      height: widget.iconSize,
      width: widget.iconSize,
      child: CustomPaint(
        painter: BeaconPainter(
            color: widget.strokeColor ?? Theme.of(context).focusColor,
            beaconRadius: _radii[index],
            maxRadius: _maxRadius,
            offset: Offset(
              widget.iconSize / 2,
              widget.iconSize / 2,
            )),
        child: _CustomNavigationBarTile(
          iconSize: widget.iconSize,
          scale: _sizes[index],
          selected: index == widget.currentIndex,
          item: widget.items[index],
          selectedColor: widget.selectedColor ?? Theme.of(context).focusColor,
          unSelectedColor:
              widget.unSelectedColor ?? Theme.of(context).disabledColor,
          iconPadding: _itemPadding,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom, 0.0);

    final height = kBottomNavigationBarHeight +
        (widget.isFloating ? 0.0 : additionalBottomPadding);

    _itemPadding = (MediaQuery.of(context).size.width -
            widget.items.length * widget.iconSize) /
        (widget.items.length * 2);

    if (widget.isFloating) {
      _itemPadding = (MediaQuery.of(context).size.width -
              widget.items.length * widget.iconSize -
              32) /
          (widget.items.length * 2);
    }

    Widget bar = Container(
      decoration: BoxDecoration(border: widget.border),
      child: Material(
        color: widget.backgroundColor ?? Theme.of(context).primaryColor,
        elevation: widget.elevation,
        shadowColor: widget.isFloating == true
            ? (widget.shadowColor ?? Theme.of(context).shadowColor)
            : Colors.transparent,
        borderRadius: BorderRadius.all(
          widget.borderRadius,
        ),
        child: SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (var i = 0; i < widget.items.length; i++)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onTap!(i);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildIcon(i),
                        _buildLabel(i),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: widget.isFloating
          ? EdgeInsets.only(
              left: 16, right: 16, top: 0, bottom: additionalBottomPadding)
          : EdgeInsets.zero,
      child: bar,
    );
  }
}

class _CustomNavigationBarTile extends StatelessWidget {
  const _CustomNavigationBarTile(
      {Key? key,
      this.selected,
      this.item,
      this.selectedColor,
      this.unSelectedColor,
      this.scale,
      this.iconSize,
      this.iconPadding})
      : super(key: key);

  final bool? selected;

  final CustomNavigationBarItem? item;

  final Color? selectedColor;

  final Color? unSelectedColor;

  final double? scale;

  final double? iconSize;

  final double? iconPadding;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.0 + scale!,
      child: Stack(
        children: [
          IconTheme(
            data: IconThemeData(
              color: selected! ? selectedColor : unSelectedColor,
              size: iconSize,
            ),
            child: selected! ? item!.selectedIcon : item!.icon,
          ),
        ],
      ),
    );
  }
}
