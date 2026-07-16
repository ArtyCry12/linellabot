[HeyGen MCP Server] — Create professional videos using HeyGen's API.

HeyGen is an AI video generation platform. This server exposes a subset of
the HeyGen API as MCP tools.

## Available Tools

### Video Creation
### Video Creation
- **create_video_agent** — Create a video from a text prompt. This is the recommended way to
  create videos. Returns a `session_id` immediately; `video_id` becomes available only after
  polling `get_video_agent_session` until status is `completed`. Always surface the session URL
  `https://app.heygen.com/video-agent/{session_id}` to the user as a clickable link so they
  can view progress in the HeyGen app.
- **create_video_from_avatar** — Create a video using a HeyGen avatar with a text script or
  audio file. Use when the user wants explicit control over avatar and voice selection.
- **create_video_from_image** — Create a video by animating a custom image with a text script
  or audio file. Use when the user provides their own image to animate.

### Video Agent Sessions
- **get_video_agent_session** — Get session status, progress, and chat messages.
- **get_video_agent_resource** — Get a single session resource by ID.
- **stop_video_agent_session** — Stop an in-progress Video Agent session.
- **list_video_agent_styles** — List available style templates (controls scene composition,
  pacing, aesthetics). Call this to discover valid `style_id` values before creating a video.
  Supports tag filtering (e.g. 'cinematic', 'retro-tech').

### Video Agent Workflow

**Default to chat mode** for video creation. Use generate mode only when the user
wants a quick, fire-and-forget video with no review.

**Chat mode** (default, recommended):
1. Call `create_video_agent` with `mode="chat"` and a descriptive prompt.
2. Surface the session URL `https://app.heygen.com/video-agent/{session_id}` to the user
   as a clickable link so they can follow progress in the HeyGen app.
3. Poll `get_video_agent_session` with the returned `session_id`.
4. When status is `waiting_for_input`, the Video Agent is asking for a decision.
   Read the latest model message — it will describe what choices are available
   (e.g. pick a voice, approve a storyboard, choose a style).
   **Show these choices to the user and ask them what they want.** Do NOT decide
   for the user — always surface the options and wait for their response.
5. Once the user responds, call `send_video_agent_message` with their choice and the `session_id`.
6. Repeat steps 3-5 until status is `completed` and `video_id` is set.
7. Once `video_id` is set, poll `get_video` with the `video_id` until `status` is `completed`,
   then return `video_url` to the user.

**Generate mode** (fire-and-forget, no review):
1. Call `create_video_agent` with a prompt. Set `mode="generate"` explicitly. Surface the
   session URL `https://app.heygen.com/video-agent/{session_id}` to the user as a clickable
   link so they can view progress in the HeyGen app.
2. Poll `get_video_agent_session` with the `session_id` until `video_id` is set.
3. Poll `get_video` with the `video_id` until `status` is `completed`.
4. Return the `video_url` to the user.

**Portrait / vertical video with `create_video_agent`:** set `orientation="portrait"` when the user asks for portrait mode, vertical video, or content for TikTok/Reels/Shorts.


### Videos
- **list_videos** — List the user's videos with optional filtering.
- **get_video** — Get details and status of a specific video by ID.
- **delete_video** — Delete a specific video by ID.

### Voices
- **create_speech** — Synthesize speech audio from text using a specified voice.
- **design_voice** — Create a custom voice from a natural language description.
- **list_voices** — List available voices with filtering by type, engine, language, and gender.
- **clone_voice** — Create a voice clone from an audio file. Returns a `voice_clone_id`; poll
  `get_voice` until status is `complete` before using the voice in video creation.
- **get_voice** — Get details for a specific voice, including clone status. Use to poll a
  voice clone until it is ready.

### Avatars

An avatar **group** is a character (person/identity). Each group contains one or more
**looks** (outfits or styles). When creating a video, you pass a **look_id** as the
`avatar_id` parameter — not the group_id.

- **list_avatar_groups** — List avatar groups (characters). Use this to browse available avatars.
- **get_avatar_group** — Get details of a specific avatar group.
- **list_avatar_looks** — List looks (outfits/styles) with optional filtering by group_id.
  The returned look_id is what you pass as `avatar_id` to video creation endpoints.
- **get_avatar_look** — Get details of a specific look.
- **create_digital_twin** — Create a digital twin from a **video** of a person speaking.
  Video must be at least 15 seconds. Requires consent from the person in the video.
- **create_photo_avatar** — Create a photo avatar from a **single image/photo** of a person.
  Use this when the user provides a photo, headshot, or image file.
- **create_prompt_avatar** — Create an AI-generated avatar from a **text description**.
  Use this when the user describes what avatar they want without providing a file.
- **create_avatar_consent** — Initiate a consent flow for an avatar group. Returns a
  consent URL that must be opened in a browser. Present this URL to the user.
- **update_avatar_look** — Rename an avatar look.

#### Choosing the Right Avatar Tool

Pick the tool based on what the user provides:
- **Photo/image** → `create_photo_avatar` (NOT create_digital_twin)
- **Video of a person speaking** → `create_digital_twin`
- **Text description only** → `create_prompt_avatar`

#### Avatar Creation & Consent Flow

Avatar creation is asynchronous. After calling a create tool, poll `get_avatar_look`
or `get_avatar_group` to check `status`: `"processing"` → still training,
`"completed"` → ready to use, `"failed"` → check the `error` field.

Digital twin avatars require consent from the person in the video. After calling
`create_digital_twin`, immediately call `create_avatar_consent` with the returned
`avatar_group_id` and present the consent URL to the user. The avatar will stay in
`"processing"` and will not finish training until the consent URL is visited.

Photo avatars and prompt avatars do not require consent.

Note: A photo avatar's group_id and its default look_id may be identical UUIDs.
This is expected — they are distinct entities. When counting avatar looks, always
call `list_avatar_looks` with a group_id filter rather than inferring from group data.

#### Engine Selection (Avatar IV vs Avatar V)

`create_video_from_avatar` defaults to the **Avatar IV** engine. **Avatar V**
(higher-quality, cross-reference-driven animation) is only available for some looks.
Each look returned by `list_avatar_looks` carries a `supported_api_engines` list —
the engine values that look accepts. Before passing an explicit `engine` (e.g.
`{"type": "avatar_v"}`), confirm that value is present in the look's
`supported_api_engines`. Do NOT pass an engine the look doesn't support.

### Video Translation
- **create_video_translation** — Translate a video into one or more target languages.
  Returns an id to poll status via `get_video_translation`.
- **list_video_translations** — List video translations with pagination.
- **get_video_translation** — Get details and status of a video translation.
- **update_video_translation** — Update a video translation's title.
- **delete_video_translation** — Delete a video translation.
- **list_video_translation_languages** — List supported target language codes.
  Call this before `create_video_translation` to validate language choices.

### Lipsyncs
- **create_lipsync** — Dub or replace audio on a video using a provided audio file.
  Runs asynchronously — poll status via `get_lipsync`.
- **list_lipsyncs** — List lipsyncs with pagination.
- **get_lipsync** — Get details and status of a lipsync.
- **update_lipsync** — Update a lipsync's title.
- **delete_lipsync** — Delete a lipsync.

### Audio
- **search_audio_sounds** — Semantically search the background-music catalog by a natural-language
  description (e.g. "upbeat lofi hip-hop", "tense cinematic riser"). Returns tracks ranked by
  similarity, each with a pre-signed download URL, plus cursor-based pagination. Currently supports
  music only (`type="music"`). Use this to find background music to pair with generated videos.

### Account
- **get_current_user** — Get current user info, remaining credits, and billing details.

### Assets
Upload a local file (image, audio, video, document) and turn it into a reusable
HeyGen asset. The flow is three steps:
1. **create_asset_upload** — Begin a presigned direct-to-S3 upload. Returns an
   `asset_id` and an `upload_url` (plus `upload_headers` that must be sent verbatim).
2. **PUT the raw file bytes** to that `upload_url` using the returned `upload_headers`.
   This is a plain HTTP PUT, not an MCP tool call.
3. **complete_asset_upload** — Finalize the upload for that `asset_id`. Poll it if it
   returns a not-ready status; on success the asset begins processing.

The resulting `asset_id` is accepted anywhere an asset ID input is expected
(e.g. `audio_asset_id`, `image_asset_id`, lipsync/translation audio inputs).

- **get_asset** — Get details and status of a specific asset by ID.
- **delete_asset** — Delete a specific asset by ID.

## NOT Available Through This Server

The following HeyGen API capabilities do NOT have MCP tools. If the user asks for
any of these, tell them it is not supported through this MCP server and suggest they
use the HeyGen API directly (https://docs.heygen.com/reference) or the HeyGen web app.
Do NOT attempt to call tools or fabricate endpoints for these — they will fail.

- **Templates** — listing, retrieving, or generating videos from templates
- **Asset listing** — enumerating or searching assets (use `get_asset` with a known asset_id instead)
- **Folders** — creating, listing, updating, or deleting folders
- **Webhooks** — creating, listing, updating, or deleting webhook endpoints
- **Streaming / Interactive Avatars** — real-time avatar sessions, WebRTC, or streaming API
- **Knowledge Base** — creating, listing, or managing knowledge bases
- **Brand Kit** — managing brand kits or themes
- **Personalized Video** — personalized video campaigns
- **Proofreading** — creating or managing video translation proofreads

## Error Handling

Tool errors return a JSON payload with `error: true`, a human-readable `message`, and
a `retryable` flag. Follow these rules:

- **Authentication errors** (`error_code: "authentication_required"`): Tell the user
  they need to reconnect their HeyGen account. Do not retry the tool.
- **Payment / quota errors** (HTTP 402, codes like `insufficient_credit`,
  `plan_upgrade_required`, `trial_limit_exceeded`): Surface the `message` to the
  user, which includes an upgrade link. Do not retry the tool.
- **Model compatibility errors** (HTTP 400, codes like `unlimited_mode_disabled` or
  messages about avatar version incompatibility, scene length, or transparent
  backgrounds): Surface the server's message and ask the user whether to adjust the
  request (e.g. split long scenes, choose a different avatar, or change settings).
  Do not retry with the same parameters. If the error is an engine mismatch on
  `create_video_from_avatar`, re-check the look's `supported_api_engines` (via
  `list_avatar_looks`) and retry with an engine that look actually supports.
- **Retryable errors** (`retryable: true`): You may retry the same call once after a
  brief pause.

## Guidelines

- Provide complete, explicit context in tool parameters. Do not rely on references
  like "the previous point" or "as discussed earlier" — always include the actual
  content being referenced.
- **Portrait / vertical video:** If the user asks for portrait mode, vertical video,
  or content for TikTok/Reels/Shorts, set `aspect_ratio="9:16"` when calling
  `create_video_from_avatar` or `create_video_from_image`. Never leave aspect ratio
  at its default when the user has expressed a portrait preference.