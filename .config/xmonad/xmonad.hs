import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Util.NamedScratchpad
import System.IO
import Data.List (elemIndex)
import Data.Maybe (fromJust)
import XMonad.Actions.CycleWS (toggleWS)

-- Launchers & Commands
myTerminal      = "kitty"
myEditor        = "nvim"
myBrowser       = "vivaldi"
myCodeEditor    = "code"
myBeyondCompare = "bcompare"

-- Color Palette (matches Kitty/Alacritty)
myTeal    = "#33cccc"
myDark    = "#0f2f2f"
myBase    = "#1c1c1c"
myText    = "#dcdccc"

-- Dmenu
myLauncher = "dmenu_run -h 36 -fn 'FiraCode Nerd Font:size=12' -nb '" ++ myDark ++ "' -nf '" ++ myText ++ "' -sb '" ++ myTeal ++ "' -sf '" ++ myDark ++ "'"

-- XMonad basics
myModMask     = mod4Mask -- Super key
myBorderWidth = 2

-- Layout
myLayout = avoidStruts $
           gaps [(U,10),(D,10),(L,10),(R,10)] $
           spacing 8 $
           layoutHook def

-- Wallpapers, Picom, Xmobar
myStartupHook = do
    spawn "picom --experimental-backends &"
    spawn "feh --bg-scale ~/downloads/wal2.jpg"
    spawn "xmobar ~/.config/xmobar/.xmobarrc"
    setWMName "xmonad"

-- Workspaces (with icons)
myWorkspaces :: [String]
myWorkspaces =
  [ "🏠 home"
  , "🌐 web"
  , "💻 dev"
  , "📝 edit"
  , "🗂 files"
  , "🎞 media"
  , "📄 docs"
  , "🖥 term"
  , "📬 mail"
  ]

-- Clickable workspace labels
clickable :: String -> String
clickable ws = "<action=`xdotool key super+" ++ show i ++ "` button=1>" ++ ws ++ "</action>"
  where
    i = 1 + fromJust (elemIndex (strip ws) myWorkspaces)
    strip = filter (`notElem` ("✅[]<>" :: String))

main = do
    xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/.xmobarrc"
    xmonad $ docks def
        { terminal           = myTerminal
        , modMask            = myModMask
        , borderWidth        = myBorderWidth
        , focusedBorderColor = myTeal
        , normalBorderColor  = myBase
        , layoutHook         = myLayout
        , startupHook        = myStartupHook
        , workspaces         = myWorkspaces
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput          = hPutStrLn xmproc
            , ppTitle           = xmobarColor myTeal "" . shorten 60
            , ppCurrent         = xmobarColor myDark myTeal . clickable . ("✅" ++)
            , ppVisible         = xmobarColor myTeal "" . clickable . wrap "<" ">"
            , ppHidden          = xmobarColor myText "" . clickable
            , ppHiddenNoWindows = const ""
            , ppSep             = "  •  "
            , ppWsSep           = "   "
            , ppOrder           = \[ws, _, t] -> [ws, t]
            }
        }
        `additionalKeys`
        [ ((myModMask, xK_Return), spawn myTerminal)
        , ((myModMask, xK_d), spawn myLauncher)
        , ((myModMask, xK_z), spawn myBrowser)
        , ((myModMask, xK_c), spawn myCodeEditor)
        , ((myModMask, xK_b), spawn myBeyondCompare)
        , ((myModMask, xK_x), kill)
        , ((myModMask .|. controlMask, xK_x), spawn "~/powermenu")
        , ((0, 0x1008FF13), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ((0, 0x1008FF11), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ((0, 0x1008FF12), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((myModMask, xK_w), spawn "nm-connection-editor")
        ]
