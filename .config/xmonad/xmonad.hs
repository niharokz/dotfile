--
--  naos · xmonad.hs · nss theme
--  DRAFTED BY [https://nih.ar] ON 23-06-2021 · LAST MODIFIED ON 03-11-2026
--

import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)          -- lets apps/xdotool see workspaces, real fullscreen
import XMonad.Hooks.SetWMName (setWMName)                        -- WM name some Java apps check
import XMonad.Hooks.StatusBar (StatusBarConfig, statusBarProp, withEasySB)  -- xmobar, no pipes
import XMonad.Hooks.StatusBar.PP                                 -- PP, xmobarColor, xmobarBorder, wrap, shorten
import XMonad.Layout.Gaps (Direction2D (..), gaps)               -- outer gaps around the screen
import XMonad.Layout.Spacing (spacing)                           -- gaps between windows
import XMonad.Util.ClickableWorkspaces (clickablePP)             -- click a workspace in xmobar to switch
import XMonad.Util.EZConfig (additionalKeys)                     -- readable key list
import XMonad.Util.SpawnOnce (spawnOnce)                         -- start once per session, not on every Mod+q

import Graphics.X11.ExtraTypes.XF86                              -- named media keys (volume, mute)

------------------------------------------------------------------------
-- 🧠 Programs

myTerminal, myBrowser, myCodeEditor, myNote, myLock :: String
myTerminal      = "kitty"
myBrowser       = "microsoft-edge-stable"
myCodeEditor    = "code"
myNote          = "obsidian"
myLock          = "naos-lock"                                    -- from the naos boot kit

------------------------------------------------------------------------
-- 🎨 nss palette (same values as nih.ar, Natlas, Median, the boot screens)

nssBg, nssSurface, nssLine, nssTeal, nssInk, nssPeri, nssAmber, nssFg, nssMuted :: String
nssBg      = "#070B0F"                                           -- background
nssSurface = "#152027"                                           -- raised surface
nssLine    = "#1F2C33"                                           -- borders, separators
nssTeal    = "#3A807A"                                           -- accent
nssInk     = "#66BDB3"                                           -- readable accent text
nssPeri    = "#A9B8FF"                                           -- second accent
nssAmber   = "#E0A63A"                                           -- warnings, urgent
nssFg      = "#E6ECEC"                                           -- text
nssMuted   = "#8B979A"                                           -- secondary text

------------------------------------------------------------------------
-- 🚀 Launcher

myLauncher :: String
myLauncher = unwords
  [ "dmenu_run -h 32 -fn 'JetBrains Mono:size=11'"
  , "-nb '" ++ nssBg ++ "' -nf '" ++ nssMuted ++ "'"             -- normal: dark bar, muted text
  , "-sb '" ++ nssSurface ++ "' -sf '" ++ nssInk ++ "'"          -- selected: raised, teal text
  , "-p '❯'"                                                     -- prompt glyph
  ]

------------------------------------------------------------------------
-- 🪟 Basics

myModMask :: KeyMask
myModMask = mod4Mask                                             -- Super key

myBorderWidth :: Dimension
myBorderWidth = 2

------------------------------------------------------------------------
-- 🧱 Layout (struts for xmobar are added by withEasySB)

-- type is long and inferred, so no signature
myLayout = gaps [(U, 10), (D, 10), (L, 10), (R, 10)] $ spacing 8 $ layoutHook def

------------------------------------------------------------------------
-- 🗂 Workspaces (emoji drawn with xmobar's font 1)

myWorkspaces :: [String]
myWorkspaces =
  [ "<fn=1>🏦</fn> 1", "<fn=1>🗿</fn> 2", "<fn=1>🍄</fn> 3"
  , "<fn=1>🍁</fn> 4", "<fn=1>🐔</fn> 5", "<fn=1>🛸</fn> 6"
  , "<fn=1>⏳</fn> 7", "<fn=1>🔥</fn> 8", "<fn=1>🗼</fn> 9"
  ]

------------------------------------------------------------------------
-- 🚀 Startup

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "picom --config ~/.config/picom/picom.conf"                         -- compositor, once per session
  spawnOnce "dunst"                                                               -- notifications (~/.config/dunst/dunstrc)
  spawnOnce "naos-battery --watch"                                                -- battery alerts (~/.config/naos/battery.conf)
  spawn "feh --no-fehbg --bg-scale $CLOUD/Photos/others/wallpaper/laptop/wallpaper_007.jpg"  -- wallpaper
  setWMName "xmonad"

------------------------------------------------------------------------
-- 📊 xmobar

naosPP :: PP
naosPP = def
  { ppCurrent         = xmobarColor nssInk "" . xmobarBorder "Bottom" nssTeal 2 . wrap " " " "  -- underlined
  , ppVisible         = xmobarColor nssPeri "" . wrap " " " "    -- shown on the other monitor
  , ppHidden          = xmobarColor nssFg "" . wrap " " " "      -- has windows
  , ppHiddenNoWindows = const ""                                 -- empty workspaces are hidden
  , ppUrgent          = xmobarColor nssAmber "" . wrap " " " "   -- needs attention
  , ppTitle           = xmobarColor nssMuted "" . shorten 60     -- focused window title
  , ppSep             = xmobarColor nssLine "" "  │  "
  , ppWsSep           = ""                                       -- each workspace already has padding
  , ppOrder           = \xs -> case xs of                        -- workspaces + title, layout name dropped
                                 (ws : _ : t : _) -> [ws, t]
                                 _                -> xs
  }

-- show/hide xmobar on Mod+Shift+b (the default Mod+b would steal the Brave shortcut)
toggleBarKey :: XConfig l -> (KeyMask, KeySym)
toggleBarKey XConfig {modMask = m} = (m .|. shiftMask, xK_b)

naosBar :: StatusBarConfig
naosBar = statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (clickablePP naosPP)  -- writes _XMONAD_LOG

------------------------------------------------------------------------
-- ⌨️ Keys (added on top of the xmonad defaults)

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  [ ((myModMask, xK_Return), spawn myTerminal)
  , ((myModMask, xK_d), spawn myLauncher)
  , ((myModMask, xK_z), spawn myBrowser)
  , ((myModMask, xK_c), spawn myCodeEditor)
  , ((myModMask, xK_b), spawn "brave-browser --incognito")
  , ((myModMask, xK_e), spawn "zsh $WORK/narch/editconfig.sh")
  , ((myModMask, xK_o), spawn myNote)
  , ((myModMask, xK_x), kill)
  , ((myModMask, xK_s), spawn "surfshark")                       -- VPN
  , ((myModMask, xK_Escape), spawn myLock)                       -- lock screen
  , ((myModMask .|. shiftMask, xK_s), spawn "flameshot gui")     -- screenshot
  , ((myModMask .|. controlMask, xK_x), spawn "$WORK/narch/powermenu.sh")
  , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  ]

------------------------------------------------------------------------
-- ⚙️ Main

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB naosBar toggleBarKey $ naosConfig

-- type is long and inferred, so no signature
naosConfig = def
  { terminal           = myTerminal
  , modMask            = myModMask
  , borderWidth        = myBorderWidth
  , focusedBorderColor = nssTeal
  , normalBorderColor  = nssLine
  , layoutHook         = myLayout
  , startupHook        = myStartupHook
  , workspaces         = myWorkspaces
  } `additionalKeys` myKeys
