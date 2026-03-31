import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/item_provider.dart';

/// Halaman form untuk menambah (CREATE) dan mengedit (UPDATE) item.
///
/// Mode ditentukan oleh parameter [item]:
/// - Jika item == null → Mode CREATE (form kosong)
/// - Jika item != null → Mode UPDATE (form terisi data item)
///
/// Fitur:
/// - TextFormField dengan validasi
/// - Loading indicator saat submit
/// - Snackbar feedback berhasil/gagal
/// - Data otomatis terisi saat mode edit
class FormPage extends StatefulWidget {
  /// Item yang akan diedit (null jika mode tambah baru)
  final ItemModel? item;

  const FormPage({super.key, this.item});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Form key untuk validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk text field
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  // Status loading saat submit
  bool _isSubmitting = false;

  /// Cek apakah dalam mode edit (update)
  bool get isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data item jika mode edit
    _nameController = TextEditingController(
      text: widget.item?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
  }

  @override
  void dispose() {
    // Bersihkan controller untuk menghindari memory leak
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Submit form: CREATE atau UPDATE berdasarkan mode
  Future<void> _submitForm() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final provider = context.read<ItemProvider>();

      if (isEditMode) {
        // MODE UPDATE: Buat item dengan data yang diperbarui
        final updatedItem = widget.item!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        await provider.updateItem(updatedItem);
      } else {
        // MODE CREATE: Tambahkan item baru
        await provider.addItem(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
        );
      }

      if (mounted) {
        // Tampilkan snackbar berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  isEditMode
                      ? 'Item berhasil diperbarui!'
                      : 'Item berhasil ditambahkan!',
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // Tampilkan snackbar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEditMode
                        ? 'Gagal memperbarui item: $e'
                        : 'Gagal menambahkan item: $e',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Item' : 'Tambah Item Baru',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEditMode ? Icons.edit_note : Icons.add_box_outlined,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEditMode
                            ? 'Perbarui informasi item di bawah ini'
                            : 'Isi form di bawah untuk menambahkan item baru',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Label field Nama
              Text(
                'Nama Item',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),

              // Input field: Nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama item...',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                textInputAction: TextInputAction.next,
                // Validasi: nama tidak boleh kosong
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama item tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama item minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Label field Deskripsi
              Text(
                'Deskripsi',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),

              // Input field: Deskripsi
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi item...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.description_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                maxLines: 4,
                textInputAction: TextInputAction.done,
                // Validasi: deskripsi tidak boleh kosong
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  if (value.trim().length < 5) {
                    return 'Deskripsi minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol submit
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isEditMode ? Icons.save : Icons.add),
                            const SizedBox(width: 8),
                            Text(
                              isEditMode ? 'Simpan Perubahan' : 'Tambah Item',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol batal
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
