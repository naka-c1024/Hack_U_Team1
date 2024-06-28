import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../../Usecases/provider.dart';

class ColorCell extends HookConsumerWidget {
  final int colorIndex;
  final bool isSheet;

  const ColorCell({
    required this.colorIndex,
    this.isSheet = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(colorProvider);
    final selectedList = ref.watch(colorListProvider);
    final isChecked = useState(false);

    useEffect(() {
      if (selectedList.contains(colorIndex)) {
        isChecked.value = true;
      }
      return null;
    }, []);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isSheet) {
            ref.read(colorProvider.notifier).state = colorIndex;
            Navigator.of(context).pop(1);
          } else {
            if (selectedList.contains(colorIndex)) {
              ref.read(colorListProvider.notifier).state.remove(colorIndex);
              isChecked.value = false;
            } else {
              ref.read(colorListProvider.notifier).state.add(colorIndex);
              isChecked.value = true;
            }
          }
        },
        child: Ink(
          width: 88,
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: colorCodes[colorIndex],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorIndex == 0
                        ? const Color(0xff000000)
                        : colorCodes[colorIndex],
                  ),
                ),
                child: isSheet
                    ? selectedIndex == colorIndex
                        ? Icon(
                            Icons.check,
                            size: 40,
                            color: colorIndex == 0
                                ? const Color(0xff000000)
                                : const Color(0xffffffff),
                          )
                        : const SizedBox()
                    : isChecked.value
                        ? Icon(
                            Icons.check,
                            size: 40,
                            color: colorIndex == 0
                                ? const Color(0xff000000)
                                : const Color(0xffffffff),
                          )
                        : const SizedBox(),
              ),
              const SizedBox(height: 8),
              Text(
                colors[colorIndex],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff4b4b4b),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
