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

Nothing of the stock tray is copied. `Tray.qml` imports the packaged
`omarchy.tray` widget from `/usr/share/omarchy` and only adds the chevron, so
every Omarchy update to the tray (menus, pinning, the manage popup) applies
here as is.

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

## How it works

`Tray.qml` extends the stock `Tray` and relies on its root properties
`expanded`, `allItems`, `pinnedItems`, `drawerCount` and `managePopupOpen`.
Followers are found among sibling bar slots through bar internals
(`ModuleSlot.moduleName` / `activeItem`) and their `trayFollower.active`. If a
future Omarchy changes these, the followers fall back to staying visible.
Pinned and hidden icons are stored under this widget's own entry in
`shell.json`.

## License

MIT, see [LICENSE](LICENSE).
