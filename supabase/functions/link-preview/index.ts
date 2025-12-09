import "https://deno.land/x/xhr@0.3.0/mod.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { DOMParser } from "https://deno.land/x/deno_dom@v0.1.38/deno-dom-wasm.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

interface LinkPreviewRequest {
  url: string;
  ig_app_id?: string;
  ig_app_secret?: string;
}

interface LinkPreviewResponse {
  image_url: string | null;
  source_url: string;
  title?: string;
  error?: string;
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { url, ig_app_id, ig_app_secret }: LinkPreviewRequest = await req.json();

    if (!url) {
      return new Response(
        JSON.stringify({ error: 'URL is required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    let imageUrl: string | null = null;
    let title: string | null = null;

    // Check if it's an Instagram link
    if (url.includes('instagram.com') || url.includes('instagr.am')) {
      console.log('Processing Instagram URL:', url);
      
      if (!ig_app_id || !ig_app_secret) {
        return new Response(
          JSON.stringify({ error: 'Instagram App ID and Secret are required for Instagram links' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Use Instagram oEmbed API
      const accessToken = `${ig_app_id}|${ig_app_secret}`;
      const encodedUrl = encodeURIComponent(url);
      const oembedUrl = `https://graph.facebook.com/v19.0/instagram_oembed?url=${encodedUrl}&access_token=${accessToken}`;

      try {
        const response = await fetch(oembedUrl);
        const data = await response.json();

        console.log('Instagram oEmbed response:', data);

        if (data.thumbnail_url) {
          imageUrl = data.thumbnail_url;
        } else if (data.author_url) {
          // Fallback: try to get profile picture or first media
          imageUrl = data.author_url;
        }

        if (data.title) {
          title = data.title;
        }
      } catch (error) {
        console.error('Instagram oEmbed error:', error);
        // Fall through to OpenGraph parsing
      }
    }

    // If not Instagram or Instagram failed, try OpenGraph / meta tags
    if (!imageUrl) {
      console.log('Processing with OpenGraph parser:', url);
      
      try {
        const response = await fetch(url, {
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; PromptBoard/1.0; +http://promptboard.app)'
          }
        });
        
        const html = await response.text();
        const doc = new DOMParser().parseFromString(html, 'text/html');

        if (!doc) {
          throw new Error('Failed to parse HTML');
        }

        // Try multiple meta tag sources for images
        const imageSources = [
          'meta[property="og:image"]',
          'meta[property="og:image:url"]',
          'meta[property="og:image:secure_url"]',
          'meta[name="twitter:image"]',
          'meta[name="twitter:image:src"]',
          'meta[property="twitter:image"]',
          'meta[itemprop="image"]',
        ];

        for (const selector of imageSources) {
          const element = doc.querySelector(selector);
          if (element) {
            const content = element.getAttribute('content');
            if (content) {
              imageUrl = content;
              console.log(`Found image from ${selector}:`, imageUrl);
              break;
            }
          }
        }

        // Try to get title
        const titleSources = [
          'meta[property="og:title"]',
          'meta[name="twitter:title"]',
          'title',
        ];

        for (const selector of titleSources) {
          const element = doc.querySelector(selector);
          if (element) {
            const content = element.getAttribute('content') || element.textContent;
            if (content) {
              title = content.trim();
              break;
            }
          }
        }

        // Special handling for Pinterest
        if (url.includes('pinterest.com') || url.includes('pin.it')) {
          // Pinterest often has high-res images in specific patterns
          const pinterestImagePatterns = [
            'meta[property="og:image"]',
            'img[class*="hCL kVc L4E MIw"]', // Pinterest's main image class
          ];

          for (const selector of pinterestImagePatterns) {
            const element = doc.querySelector(selector);
            if (element) {
              const src = element.getAttribute('content') || element.getAttribute('src');
              if (src && src.includes('pinimg.com')) {
                // Pinterest images are usually on i.pinimg.com
                imageUrl = src.replace(/\/\d+x\//, '/originals/'); // Get original size
                console.log('Found Pinterest image:', imageUrl);
                break;
              }
            }
          }
        }

      } catch (error) {
        console.error('OpenGraph parsing error:', error);
      }
    }

    // Make sure image URL is absolute
    if (imageUrl && !imageUrl.startsWith('http')) {
      try {
        const baseUrl = new URL(url);
        imageUrl = new URL(imageUrl, baseUrl.origin).toString();
      } catch (error) {
        console.error('Error converting to absolute URL:', error);
      }
    }

    const response: LinkPreviewResponse = {
      image_url: imageUrl,
      source_url: url,
      title: title || undefined,
    };

    if (!imageUrl) {
      response.error = 'No image found for this URL';
    }

    return new Response(
      JSON.stringify(response),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );

  } catch (error) {
    console.error('Function error:', error);
    return new Response(
      JSON.stringify({ 
        error: error.message || 'Internal server error',
        source_url: null,
        image_url: null,
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
});
