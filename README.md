# Revision Voice Notes

A spoken index for DSA / SQL revision. Sections → topics → methods → voice recordings.

Live: https://pasupuletiSaiM.github.io/revision-voice-notes/

## Use

- **New** creates a section, topic or method depending on where you are.
- Open a method → **+ Add approach** → record with your mic, or upload an audio file.
- **▶** plays, **rename** / **delete** do what they say. Deleting always asks first.
- **Speed** gives 1×–2× playback. **Search** covers every level at once.

## Where recordings live

In your browser's own storage (IndexedDB), per device. The site is static, so there is
no server holding your audio. Use **Export backup** to download a single `.json`
containing everything, and **Import** to restore it on another machine.

## Sync setup (Supabase)

1. Create a project at supabase.com.
2. SQL Editor → paste `supabase-setup.sql` → Run. This creates the table,
   the private `recordings` bucket, and row-level security so only you can
   reach your own rows and files.
3. Settings → API → copy the Project URL and the **anon public** key into
   `config.js`.

Leaving `config.js` blank is fine — the site then saves to the local browser
only, exactly as before.
