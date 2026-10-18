# System tray for the Omarchy bar, with a group chevron

[![Ko-fi](https://img.shields.io/badge/Ko--fi-support-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/mike_g)

The stock Omarchy system tray, unchanged, except for one thing: while no
application has a tray icon, it still shows its `‹` chevron if widgets that
hide with the tray drawer sit next to it. Hover the chevron and those widgets
slide out, exactly as they do when the tray has icons.

Without this, the stock tray hides itself completely when it is empty (by
design, like Waybar's tray), so tray-following widgets have nothing to reveal
them and simply stay visible. With it there is always exactly one chevron in
the same place, whether or not any tray app is running.

## Install

```sh
omarchy plugin add https://github.com/yesm1ke/omarchy-plugin-tray --enable
omarchy plugin disable omarchy.tray   # the stock widget it replaces
```

Then make sure `io.github.yesm1ke.tray` is the first widget of the right
section (the bar only keeps the stock `omarchy.tray` id pinned there
automatically), followed by the tray-following widgets:

```sh
omarchy bar move io.github.yesm1ke.tray --section right --index 0
```

Requires Omarchy 4.

## Tray-following widgets

Any widget that uses the `TrayFollower.qml` helper, currently:

- [omarchy-plugin-zerotier](https://github.com/yesm1ke/omarchy-plugin-zerotier)
- [omarchy-plugin-tailscale](https://github.com/yesm1ke/omarchy-plugin-tailscale)
- [omarchy-plugin-bluetooth](https://github.com/yesm1ke/omarchy-plugin-bluetooth)

Place them right after the tray. With no followers in the layout (or all of
them set to `hideWithTray: false`) this widget behaves exactly like the stock
tray.

## Behaviour

- With tray icons: identical to the stock tray.
- Without tray icons, with followers: a chevron alone; hover reveals the
  followers, right click opens the usual tray manager.
- All icons hidden via the manager: the stock tray would disappear together
  with its manager; here it stays, so hidden icons can be brought back.

## Staying current with Omarchy

This is a copy of the stock widget with the change above on top. Until Omarchy
4.0.5 it was a wrapper that imported the packaged `omarchy.tray` widget from `/usr/share/omarchy`
and copied nothing, but with Qt 6.12 such an import no longer works when the
stock file declares inline components (`component Foo: …`; the widget fails to
load with "Foo is not a type"), so it became a copy. The repository keeps
Omarchy's files and ours apart:

- branch `upstream` holds the stock files exactly as Omarchy ships them, one
  commit per Omarchy version that changed them;
- branch `main` is `upstream` plus the change described above (`Tray.qml`, marked `io.github.yesm1ke`, before the root's size).

After an Omarchy update, run `./sync-upstream` in the installed plugin
(`~/.config/omarchy/plugins/<id>/`). It records the installed stock files on
`upstream` and merges them into `main`; on a conflict it aborts the merge and
leaves everything as it was, to be resolved with `git merge upstream`.
`./sync-upstream --check` only reports whether anything changed. It can be run
automatically from an Omarchy `post-update` hook.

## How it works

`Tray.qml` is the stock tray; the added code relies on its root properties
`expanded`, `allItems`, `pinnedItems`, `drawerCount` and `managePopupOpen`.
Followers are found among sibling bar slots through bar internals
(`ModuleSlot.moduleName` / `activeItem`) and their `trayFollower.active`. If a
future Omarchy changes these, the followers fall back to staying visible.
Pinned and hidden icons are stored under this widget's own entry in
`shell.json`.

## License

MIT, see [LICENSE](LICENSE). Based on the Omarchy tray widget, © David
Heinemeier Hansson, MIT.
