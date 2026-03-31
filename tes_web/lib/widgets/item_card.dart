import 'package:flutter/material.dart';
import '../models/item_model.dart';

/// Widget reusable Card untuk menampilkan satu item dalam list.
///
/// Menampilkan nama dan deskripsi item dalam Card yang rapi,
/// dengan tombol aksi untuk edit dan delete.
class ItemCard extends StatelessWidget {
  /// Data item yang ditampilkan
  final ItemModel item;

  /// Callback ketika tombol edit ditekan
  final VoidCallback onEdit;

  /// Callback ketika tombol delete ditekan
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris atas: ID badge + action buttons
              Row(
                children: [
                  // Badge ID item
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#${item.id}',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Tombol edit
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: onEdit,
                    tooltip: 'Edit item',
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tombol delete
                  IconButton(
                    icon: Icon(
                      Icons.delete_outlined,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Hapus item',
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.error.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nama item
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Deskripsi item
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
