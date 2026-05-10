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

All ratings and accounts are saved in your browser's `localStorage`. This means:

- ✅ Stays logged in across page reloads
- ✅ Multiple people can have accounts on the same device
- ❌ Doesn't sync across devices (your phone and laptop are separate)

## Settings

Every user has a **Settings** gear (⚙) in the app:
- Toggle **light mode**
- Change your **password**

## Admin

The admin account is `justin` (change the `ADMIN_USERNAME` constant in `app.html` to your username). Admins get an extra section in Settings to **edit any user's username or password**.
