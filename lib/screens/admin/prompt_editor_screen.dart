import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/prompt_model.dart';
import '../../core/providers.dart';
import '../../providers/auth_provider.dart';

/// Screen for creating/editing prompts
class PromptEditorScreen extends ConsumerStatefulWidget {
  final PromptModel? existingPrompt;

  const PromptEditorScreen({
    super.key,
    this.existingPrompt,
  });

  @override
  ConsumerState<PromptEditorScreen > createState() => _PromptEditorScreenState();
}

class _PromptEditorScreenState extends ConsumerState<PromptEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _promptTextController = TextEditingController();
  final _tagsController = TextEditingController();
  final _modelNameController = TextEditingController();
  final _negativePromptController = TextEditingController();
  final _creatorNameController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();

  ModelProvider _selectedProvider = ModelProvider.chatgpt;
  bool _isFeatured = false;
  bool _useUpload = true;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingPrompt != null) {
      _loadExistingPrompt();
    }
  }

  void _loadExistingPrompt() {
    final prompt = widget.existingPrompt!;
    _titleController.text = prompt.title;
    _promptTextController.text = prompt.promptText;
    _tagsController.text = prompt.tags.join(', ');
    _selectedProvider = prompt.modelProvider ?? ModelProvider.chatgpt;
    _modelNameController.text = prompt.modelName ?? '';
    _negativePromptController.text = prompt.negativePrompt ?? '';
    _creatorNameController.text = prompt.creatorName ?? '';
    _sourceUrlController.text = prompt.sourceUrl ?? '';
    _imageUrlController.text = prompt.imageUrl ?? '';
    _isFeatured = prompt.isFeatured;
    _useUpload = false; // Default to URL for existing prompts
  }

  @override
  void dispose() {
    _titleController.dispose();
    _promptTextController.dispose();
    _tagsController.dispose();
    _modelNameController.dispose();
    _negativePromptController.dispose();
    _creatorNameController.dispose();
    _sourceUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePrompt() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate image
    if (_useUpload && _selectedImage == null && widget.existingPrompt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    if (!_useUpload && _imageUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an image URL')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('Not authenticated');

      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final now = DateTime.now();
      final prompt = PromptModel(
        id: widget.existingPrompt?.id ?? '',
        title: _titleController.text.trim(),
        promptText: _promptTextController.text.trim(),
        tags: tags,
        imageUrl: _useUpload ? '' : _imageUrlController.text.trim(),
        sourceUrl: _sourceUrlController.text.trim().isEmpty
            ? null
            : _sourceUrlController.text.trim(),
        thumbnailUrl: null,
        modelProvider: _selectedProvider,
        modelName: _modelNameController.text.trim(),
        negativePrompt: _negativePromptController.text.trim().isEmpty
            ? null
            : _negativePromptController.text.trim(),
        creatorName: _creatorNameController.text.trim().isEmpty
            ? null
            : _creatorNameController.text.trim(),
        sourceUserName: null,
        isFeatured: _isFeatured,
        createdByUserId: currentUser.id,
        createdAt: widget.existingPrompt?.createdAt ?? now,
        updatedAt: now,
      );

      final repository = ref.read(promptRepositoryProvider);

      if (widget.existingPrompt != null) {
        // Update existing
        await repository.updatePrompt(
          prompt: prompt,
          newImageFile: _useUpload ? _selectedImage : null,
        );
      } else {
        // Create new
        await repository.createPrompt(
          prompt: prompt,
          imageFile: _useUpload ? _selectedImage : null,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingPrompt != null
                ? 'Prompt updated successfully'
                : 'Prompt created successfully'),
          ),
        );
        context.go('/');  // Navigate to home to show new prompts immediately
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving prompt: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingPrompt != null ? 'Edit Prompt' : 'Create Prompt'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter prompt title',
              ),
              validator: (value) => value?.trim().isEmpty ?? true
                  ? 'Please enter a title'
                  : null,
            ),
            const SizedBox(height: 16),

            // Prompt text
            TextFormField(
              controller: _promptTextController,
              decoration: const InputDecoration(
                labelText: 'Prompt Text *',
                hintText: 'Enter the full prompt',
              ),
              maxLines: 5,
              validator: (value) => value?.trim().isEmpty ?? true
                  ? 'Please enter prompt text'
                  : null,
            ),
            const SizedBox(height: 16),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags *',
                hintText: 'Cinematic, Golden-Hour, Portrait (comma separated)',
              ),
              validator: (value) => value?.trim().isEmpty ?? true
                  ? 'Please enter at least one tag'
                  : null,
            ),
            const SizedBox(height: 16),

            // Model provider dropdown
            DropdownButtonFormField<ModelProvider>(
              value: _selectedProvider,
              decoration: const InputDecoration(
                labelText: 'AI Model Provider *',
              ),
              items: ModelProvider.values.map((provider) {
                return DropdownMenuItem(
                  value: provider,
                  child: Text(provider.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedProvider = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Model name
            TextFormField(
              controller: _modelNameController,
              decoration: const InputDecoration(
                labelText: 'Model Name *',
                hintText: 'e.g., GPT-4.1, Claude 4.5 Sonnet, Gemini 2.5',
              ),
              validator: (value) => value?.trim().isEmpty ?? true
                  ? 'Please enter model name'
                  : null,
            ),
            const SizedBox(height: 16),

            // Negative prompt (optional)
            TextFormField(
              controller: _negativePromptController,
              decoration: const InputDecoration(
                labelText: 'Negative Prompt (Optional)',
                hintText: 'Enter negative prompt if applicable',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Creator name (optional)
            TextFormField(
              controller: _creatorNameController,
              decoration: const InputDecoration(
                labelText: 'Creator Name (Optional)',
                hintText: 'Original creator of this prompt',
              ),
            ),
            const SizedBox(height: 16),

            // Source URL (optional)
            TextFormField(
              controller: _sourceUrlController,
              decoration: const InputDecoration(
                labelText: 'Source URL (Optional)',
                hintText: 'https://instagram.com/...',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),

            // Image source selector
            const Text(
              'Image Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Upload Image'),
                    value: true,
                    groupValue: _useUpload,
                    onChanged: (value) {
                      setState(() => _useUpload = value ?? true);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Image URL'),
                    value: false,
                    groupValue: _useUpload,
                    onChanged: (value) {
                      setState(() => _useUpload = value ?? true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Image upload or URL input
            if (_useUpload) ...[
              // Upload button
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ] else ...[
              // URL input
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
              ),
            ],
            const SizedBox(height: 24),

            // Featured toggle
            SwitchListTile(
              title: const Text('Featured Prompt'),
              subtitle: const Text('Show in featured section'),
              value: _isFeatured,
              onChanged: (value) {
                setState(() => _isFeatured = value);
              },
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _savePrompt,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(widget.existingPrompt != null ? 'Update Prompt' : 'Create Prompt'),
            ),
          ],
        ),
      ),
    );
  }
}
