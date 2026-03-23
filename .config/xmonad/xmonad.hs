import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps

import System.IO
import Data.List (elemIndex)


--- ────────────────────────────
--- 🧠 Core Programs

myTerminal      = "kitty"
myEditor        = "nvim"
myBrowser       = "microsoft-edge-stable"
myCodeEditor    = "code"
myBeyondCompare = "bcompare"


--- ────────────────────────────
--- 🎨 Colors

myTeal  = "#42938C"
myDark  = "#0f2f2f"
myBase  = "#1c1c1c"
myText  = "#dcdccc"
myBlack = "#000000"


--- ────────────────────────────
--- 🚀 Launcher (Dmenu)

myLauncher =
  "dmenu_run -h 32 -fn 'FiraCode Nerd Font:size=12' " ++
  "-nb '" ++ myBlack ++ "' -nf '" ++ myTeal ++ "' " ++
  "-sb '" ++ myDark  ++ "' -sf '" ++ myText ++ "'"


--- ────────────────────────────
--- 🪟 Window Manager Basics

myModMask     = mod4Mask
myBorderWidth = 2


--- ────────────────────────────
--- 🧱 Layout

myLayout =
  avoidStruts $
  gaps [(U,10),(D,10),(L,10),(R,10)] $
  spacing 8 $
  layoutHook def


--- ────────────────────────────
--- 🗂 Workspaces (Emoji via xmobar font index)

myWorkspaces =
  [ "<fn=1>🗿</fn> 1"
  , "<fn=1>💀</fn> 2"
  , "<fn=1>📡</fn> 3"
  , "<fn=1>🐶</fn> 4"
  , "<fn=1>💐</fn> 5"
  , "<fn=1>⏳</fn> 6"
  , "<fn=1>🔥</fn> 7"
  , "<fn=1>🍃</fn> 8"
  , "<fn=1>🗼</fn> 9"
  ]


--- ────────────────────────────
--- 🖱 Clickable Workspaces

clickable :: String -> String
clickable ws =
  "<action=`xdotool key super+" ++ show i ++ "` button=1>" ++ ws ++ "</action>"
  where
    i = maybe 1 (+1) (elemIndex ws myWorkspaces)


--- ────────────────────────────
--- 🚀 Startup

myStartupHook = do
  spawn "picom --config ~/.config/picom/picom.conf &"
  spawn "feh --bg-scale $CLOUD/Photos/others/wallpaper/laptop/wallpaper_007.jpg"
  setWMName "xmonad"


--- ────────────────────────────
--- 📊 Xmobar Log

myLogHook xmproc =
  dynamicLogWithPP xmobarPP
    { ppOutput          = hPutStrLn xmproc
    , ppCurrent         = xmobarColor myDark myTeal . clickable . wrap "[" "]"
    , ppVisible         = xmobarColor myTeal "" . clickable . wrap "(" ")"
    , ppHidden          = xmobarColor myText "" . clickable
    , ppHiddenNoWindows = xmobarColor "#555555" "" . clickable
    , ppTitle           = xmobarColor myTeal "" . shorten 60
    , ppSep             = "  •  "
    , ppWsSep           = "   "
    , ppOrder           = \[ws, _, t] -> [ws, t]
    }


--- ────────────────────────────
--- ⚙️ Main

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar ~/.config/xmobar/.xmobarrc"

  xmonad $ docks def
    { terminal           = myTerminal
    , modMask            = myModMask
    , borderWidth        = myBorderWidth
    , focusedBorderColor = myTeal
    , normalBorderColor  = myBase
    , layoutHook         = myLayout
    , startupHook        = myStartupHook
    , workspaces         = myWorkspaces
    , logHook            = myLogHook xmproc
    }
    `additionalKeys`
    myKeys


--- ────────────────────────────
--- ⌨️ Keybindings

myKeys =
  [ ((myModMask, xK_Return), spawn myTerminal)
  , ((myModMask, xK_d), spawn myLauncher)
  , ((myModMask, xK_z), spawn myBrowser)
  , ((myModMask, xK_c), spawn myCodeEditor)
  , ((myModMask, xK_b), spawn "brave-browser")

  , ((myModMask, xK_e), spawn "zsh $WORK/narch/editconfig.sh")
  , ((myModMask, xK_x), kill)

  , ((myModMask .|. shiftMask,   xK_s), spawn "flameshot gui")
  , ((myModMask .|. controlMask, xK_x), spawn "$WORK/narch/powermenu.sh")

  -- Volume Keys
  , ((0, 0x1008FF13), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ((0, 0x1008FF11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ((0, 0x1008FF12), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

  -- Network Manager
  , ((myModMask, xK_w), spawn "nm-connection-editor")
  ]
