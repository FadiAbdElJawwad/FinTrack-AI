import 'package:flutter/material.dart';
import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../domain/models/transaction_model.dart';
import '../utils/transaction_category_extension.dart';

class CategorySelector extends StatelessWidget {
  final List<TransactionCategory> categories;
  final TransactionCategory? selectedCategory;
  final Function(TransactionCategory) onSelect;

  const CategorySelector({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...categories.map((cat) {
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat.getLocalizedName(context)),
                selected: isSelected,
                onSelected: (_) => onSelect(cat),
                selectedColor: ColorManager.primaryBlue,
                backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                labelStyle: context.labelSmall.copyWith(
                  color: isSelected
                      ? Colors.white
                      : ColorManager.secondaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide.none,
                ),
                showCheckmark: false,
              ),
            );
          }),
          ActionChip(
            label: Text(context.loc.more),
            onPressed: () {},
            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            labelStyle: context.labelSmall.copyWith(
              color: ColorManager.secondaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}
