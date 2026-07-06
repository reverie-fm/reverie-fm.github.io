# Reverie — Personal Music Rankings

Rate tracks 1–10, browse albums as vinyl records, and track your listening stats.

## Files

| File | Purpose |
|---|---|
| `index.html` | Landing page |
| `app.html` | The app |

## Deploying to GitHub Pages

1. Push both files to your GitHub repo.
2. Go to **Settings → Pages**, set source to your main branch, root folder.
3. Your site will be live at `https://yourusername.github.io/repo-name/`.

## Spotify

Spotify search works out of the box — no setup needed. The API credentials are already built in.

## Accounts & Data

Ratings and accounts are stored in **Supabase**, so everything syncs across devices automatically. `localStorage` is still used for lightweight per-device preferences (light mode, avatars).

- ✅ Stays logged in across page reloads
- ✅ Syncs across devices
- ✅ Multiple accounts supported

## Settings

Every user has a **Settings** gear (⚙) in the app:

- Toggle **light mode**
- Change your **password**

## Admin

Admin status is managed in Supabase — set `is_admin = true` on a user's row in the `profiles` table to grant them admin access. Admins get an extra section in Settings to **edit any user's username or password, or delete their account**.

## Forgot Password

Users who can't log in can reach you via the **"Forgot password? Get in touch ↗"** link on the login screen, which points to the contact section of the landing page.
