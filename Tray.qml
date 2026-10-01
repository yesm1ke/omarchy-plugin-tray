import QtQuick
import qs.Commons
import qs.Ui
import "file:///usr/share/omarchy/shell/plugins/bar/widgets" as Stock

// The stock system tray, unmodified, plus one thing: a chevron while the tray
// has no icons, as long as a tray-following widget (TrayFollower) sits next
// to it. Stock Tray hides itself, chevron included, when no application has
// a tray icon, which would leave the followers with nothing to reveal them.
//
// Nothing is copied: Stock.Tray is the packaged omarchy.tray widget, so
// Omarchy updates to it apply here automatically. The stock chevron and ours
// are never shown together: ours only exists while Stock.Tray reports no
// items at all (allItems), which is exactly when the stock one is gone.
Stock.Tray {
  id: wrapper

  // The ModuleSlot that hosts this widget (widget -> Loader -> ModuleSlot),
  // found the same way TrayFollower finds it.
  readonly property var slot: {
    var p = wrapper.parent
    for (var i = 0; i < 4 && p; i++) {
      if (p.moduleName !== undefined && p.activeItem !== undefined) return p
      p = p.parent
    }
    return null
  }
  readonly property var siblings: slot && slot.parent ? slot.parent.children : []
  readonly property bool hasFollowers: {
    for (var i = 0; i < siblings.length; i++) {
      var item = siblings[i] ? siblings[i].activeItem : null
      var follower = item ? item.trayFollower : null
      if (follower && follower.active === true) return true
    }
    return false
  }
  readonly property bool ownChevron: hasFollowers && allItems.length === 0

  // The stock content loader sizes the stock tray; find it among the
  // children rather than relying on its id, which is private to Stock.Tray.
  readonly property var stockContent: {
    var kids = wrapper.children
    for (var i = 0; i < kids.length; i++)
      if (kids[i] && kids[i] !== chevronArea && kids[i].sourceComponent !== undefined) return kids[i]
    return null
  }

  // Stock: visible only with pinned or drawer icons. Followers also keep the
  // tray up when every icon is hidden, so its chevron and manage menu stay
  // reachable.
  visible: pinnedItems.length > 0 || drawerCount > 0 || hasFollowers
  implicitWidth: vertical ? barSize
    : (ownChevron ? chevron.implicitWidth : (stockContent ? stockContent.implicitWidth : 0))
  implicitHeight: !vertical ? barSize
    : (ownChevron ? chevron.implicitHeight : (stockContent ? stockContent.implicitHeight : 0))

  Item {
    id: chevronArea
    visible: wrapper.ownChevron
    width: chevron.implicitWidth
    height: chevron.implicitHeight

    HoverHandler {
      onHoveredChanged: wrapper.expanded = hovered
    }

    // Same button, glyph and actions as the stock chevron.
    BarIconButton {
      id: chevron
      bar: wrapper.bar
      width: implicitWidth
      height: implicitHeight
      text: ""
      textRotation: wrapper.vertical ? 90 : 0
      onPressed: function(button) {
        if (button === Qt.RightButton) wrapper.managePopupOpen = !wrapper.managePopupOpen
      }
    }
  }
}
