# Salama Dar: test report

Tested 3 October 2026 on a local server, Chromium, at 390×844 (phone, touch) and 1366×800
(desktop), in light and dark mode, in Kiswahili and English.

## Automated user-flow tests: 43 of 43 passed, 0 JavaScript errors

| # | Flow | Result |
|---|---|---|
| 1–4 | First-run welcome opens, switches language, closes, stays closed after reload | Pass |
| 5–6 | Map opens with the ward list sheet; tapping a ward on the map opens its details | Pass |
| 7–8 | Typing "jang" + Enter finds Jangwani and zooms to about 4.8 km across | Pass |
| 9–10 | Sheet expands; "Report flooding in this ward" opens the form with the ward filled in | Pass |
| 11–13 | Prototype-mode notice shows; empty submit shows 3 specific errors; focus jumps to the first | Pass |
| 14–16 | Valid report sends, shows confirmation, appears in "Your reports", then "On the map" | Pass |
| 17–19 | Approved report shows as a numbered bubble, in the legend count and in the ward details | Pass |
| 20–21 | All five sections and About render; the phone Back button returns to the previous section | Pass |
| 22–23 | English ward details; language choice remembered after reload | Pass |
| 24–26 | Service worker installs; app loads with no connection; offline banner appears | Pass |
| 27–28 | Report reviewed on `moderate.html` appears on the map | Pass |
| 29 | Desktop: side panel instead of bottom sheet, top navigation instead of tab bar | Pass |
| 36–40 | Preparation checklist ticks, progress and reload; health topics expand; emergency tiles dial the right numbers | Pass |
| 30–35 | TMA desk: opens with the official TMA link, 4-point check before sharing, 6th tab, daily calendar reminder downloads, map legend links to it | Pass |

Load: first contentful paint about 90 ms locally; the whole app is about 160 KB before compression.

## UX/UI audit probes (WCAG 2.2 measurements)

| Check | Result |
|---|---|
| Text contrast | 902 text elements measured across 7 sections × 2 languages × 2 themes: 0 failures |
| Tap targets (SC 2.5.8) | 0 below 24 px after fixes (was 2: the "not an official warning" link at 20 px tall and the 22 px checkbox) |
| Accessible names | 0 unnamed controls; every form field has a label |
| Keyboard focus (SC 2.4.7) | Visible 3 px outline on 13 of 13 controls tabbed through |
| Choice load (Hick) | 13–14 interactive items on first screen (index 3.7–3.9), inside the typical 8–15 range |
| Kiswahili/English parity | Same headings, same number of controls and same structure in both languages on every section |

Fixed during testing: the two small tap targets; too much bold text (81% → 45% on the report
form); missing pressed and disabled states on buttons; the form now asks required questions first;
a desktop layout bug where the details panel sat under the map; crowded phone header; the map
opening zoomed out when the app started on another tab; a selected ward hiding behind the panel.

Judgment calls left as they are: the search box sits at the top of the map, which is the
familiar pattern from map apps but is a stretch for one-handed use. The ward list in the bottom
sheet gives a thumb-reachable path to every listed ward.

## What these tests cannot tell you

- Live database mode was not tested end to end, because the test machine cannot reach Supabase.
  The database rules are in `supabase/schema.sql`; test them once your project exists.
- Whether the Kiswahili reads naturally. The probes check structure, not language quality.
- How it feels on a low-cost Android phone on a slow connection. Test that on a real device.
- Whether residents understand that this is not an official warning. Only people can tell you that.

## Testing with residents: a 30-minute session, 5 people

Five people find most of the serious problems. Use each person's own phone, sit beside them,
don't help, and note where they hesitate.

Say first: "We are testing the app, not you. Think out loud."

| Task (read it aloud) | Success looks like |
|---|---|
| 1. Tafuta kama kata unayoishi iko kwenye orodha. | Finds their ward in under 30 seconds |
| 2. Kama unaishi Jangwani, umuulize nani kuhusu njia ya kuhama? | Finds "Uliza nani" without help |
| 3. Umeona maji yamefika magotini Tandale. Ripoti. | Sends the report in under 60 seconds |
| 4. Mtoto anaharisha maji mengi baada ya mafuriko. Ufanye nini? | Finds ORS and "go to a health facility" |
| 5. Piga namba ya huduma za maafa (usipige kweli). | Opens the 190 dialler |
| 6. Badilisha lugha iwe Kiingereza. | Finds SW/EN in under 10 seconds |
| 7. Je, programu hii ni tahadhari rasmi ya serikali? | Says no; official warnings come from TMA |

After each task ask: "Kwa kipimo cha 1 hadi 7, ilikuwa rahisi kiasi gani?"
Fix anything that 2 or more people struggle with, then test with 5 new people.
