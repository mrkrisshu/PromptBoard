# Link Preview Edge Function

This Supabase Edge Function converts Instagram/Pinterest/any URL to a direct image URL.

## Features

- ✅ Instagram links → Uses Meta oEmbed API
- ✅ Pinterest links → Extracts high-res image
- ✅ Any website → Parses OpenGraph/Twitter meta tags
- ✅ Returns direct image URL for storage

## Deployment

```bash
# Make sure you're in the project root
cd C:\Users\mrkri\Desktop\PromptBoard

# Deploy the function
supabase functions deploy link-preview

# Set your Instagram credentials as secrets
supabase secrets set IG_APP_ID=your_app_id_here
supabase secrets set IG_APP_SECRET=your_app_secret_here
```

## Usage in Flutter

```dart
// In your prompt editor or repository
Future<String?> getImageFromUrl(String url) async {
  try {
    final response = await Supabase.instance.client.functions.invoke(
      'link-preview',
      body: {
        'url': url,
        'ig_app_id': 'YOUR_IG_APP_ID',  // Or load from env
        'ig_app_secret': 'YOUR_IG_APP_SECRET',
      },
    );

    if (response.data != null) {
      final imageUrl = response.data['image_url'];
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl as String;
      }
    }
  } catch (e) {
    print('Error fetching image from URL: $e');
  }
  
  return null;  // Return null if failed, use original URL
}
```

## Example Responses

### Instagram Success:
```json
{
  "image_url": "https://scontent.cdninstagram.com/v/t51.../image.jpg",
  "source_url": "https://www.instagram.com/p/ABC123/",
  "title": "Check out this amazing photo"
}
```

### Pinterest Success:
```json
{
  "image_url": "https://i.pinimg.com/originals/ab/cd/ef/abcdef123456.jpg",
  "source_url": "https://pin.it/xyz",
  "title": "Beautiful sunset landscape"
}
```

### Error Response:
```json
{
  "image_url": null,
  "source_url": "https://example.com/page",
  "error": "No image found for this URL"
}
```

## Testing

Test with these URLs:

**Instagram** (requires valid App ID/Secret):
```
https://www.instagram.com/p/ABC123/
```

**Pinterest**:
```
https://pin.it/xyz
https://www.pinterest.com/pin/123456789/
```

**Unsplash** (should work via OpenGraph):
```
https://unsplash.com/photos/abc123
```

## Error Handling

The function gracefully handles:
- Invalid URLs
- Missing Instagram credentials
- Network failures
- Missing meta tags
- Malformed HTML

If it can't find an image, it returns:
```json
{
  "image_url": null,
  "error": "No image found for this URL"
}
```

Your app should handle this by either:
1. Using the original URL as fallback
2. Showing an error to the user
3. Asking for a different URL
