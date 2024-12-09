part of 'nav_flex.dart';

/// The `DraggableHistoryButton` is a floating button widget that allows
/// users to view and navigate through navigation history dynamically.
///
/// ### Features:
/// - Draggable across the screen.
/// - Toggleable history box to view routes.
/// - Customizable button size, colors, and icons.
///
/// ### Example:
/// ```dart
/// DraggableHistoryButton(
///   buttonColor: Colors.blue,
///   openIcon: Icons.history,
///   closeIcon: Icons.close,
/// );
/// ```
class DraggableHistoryButton extends StatefulWidget {
  final Color? buttonColor;
  final IconData? openIcon;
  final IconData? closeIcon;
  final double? buttonSize;
  final double? historyBoxWidth;
  final double? historyBoxHeight;
  final ImageProvider? imageProvider;

  const DraggableHistoryButton({
    super.key,
    this.buttonColor,
    this.openIcon,
    this.closeIcon,
    this.buttonSize,
    this.historyBoxWidth,
    this.historyBoxHeight,
    this.imageProvider,
  });

  @override
  State<DraggableHistoryButton> createState() => _DraggableHistoryButtonState();
}

class _DraggableHistoryButtonState extends State<DraggableHistoryButton> {
  Offset _buttonPosition = const Offset(50, 100);
  bool _isHistoryVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = widget.buttonSize ?? 60.0;
    final historyBoxWidth = widget.historyBoxWidth ?? 200.0;
    final historyBoxHeight = widget.historyBoxHeight ?? 300.0;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: _buttonPosition.dx,
            top: _buttonPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final dx = _buttonPosition.dx + details.delta.dx;
                  final dy = _buttonPosition.dy + details.delta.dy;

                  _buttonPosition = Offset(
                    dx.clamp(0, screenSize.width - buttonSize),
                    dy.clamp(0, screenSize.height - buttonSize),
                  );
                });
              },
              onTap: () {
                setState(() {
                  _isHistoryVisible = !_isHistoryVisible;
                });
              },
              child: CircleAvatar(
                radius: buttonSize / 2,
                backgroundColor: widget.buttonColor ?? Colors.blue,
                child: widget.imageProvider != null
                    ? ClipOval(
                        child: Image(
                          image: widget.imageProvider!,
                          fit: BoxFit.cover,
                          width: buttonSize,
                          height: buttonSize,
                        ),
                      )
                    : Icon(
                        _isHistoryVisible ? (widget.closeIcon ?? Icons.close) : (widget.openIcon ?? Icons.history),
                        color: Colors.white,
                        size: buttonSize / 2,
                      ),
              ),
            ),
          ),
          if (_isHistoryVisible)
            Positioned(
              left: (_buttonPosition.dx + buttonSize > screenSize.width - historyBoxWidth)
                  ? _buttonPosition.dx - historyBoxWidth
                  : _buttonPosition.dx + buttonSize,
              top: _buttonPosition.dy,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: historyBoxWidth,
                    maxHeight: historyBoxHeight,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: NavigationService.history.length,
                    itemBuilder: (context, index) {
                      String routeName = NavigationService.history[index];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            NavigationService.popUntil(routeName);
                          });
                        },
                        leading: const Icon(Icons.circle, size: 10),
                        title: Text(
                          routeName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
