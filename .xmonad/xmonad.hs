import XMonad
import System.IO
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog   (PP(..), dynamicLogWithPP, xmobarPP, wrap, defaultPP)
import XMonad.Hooks.UrgencyHook
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders(smartBorders, noBorders)
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Util.SpawnOnce

myModMask :: KeyMask
myModMask = mod4Mask

myFont :: String
myFont = "xft:FiraCode:size=10:antialias=true"

myTerminal :: String
myTerminal = "termite"

browser :: String
browser = "brave"

editor :: String
editor = "code"

launcher :: String
launcher= "dmenu_run -m 0 -fn Firacode:size=10 -nb black -nf white -sb '#42938C'"

myBorderWidth :: Dimension
myBorderWidth = 2

myNormalBorderColor :: String
myNormalBorderColor  = "#666666"

myFocusedBorderColor :: String
myFocusedBorderColor = "#42938C"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]


myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((0, xK_KP_Enter), spawn $ XMonad.terminal conf)
    , ((modm, xK_b), spawn $ browser)
    , ((0, xK_KP_Add), spawn $ browser)
    , ((0, xK_KP_Subtract), spawn $ browser ++ " -incognito")
    , ((modm, xK_c), spawn $ editor)
    , ((0, xK_KP_Multiply), spawn $ editor)
    , ((modm,               xK_d     ), spawn $ launcher)
    , ((0, xK_Menu), spawn $ launcher)
    , ((modm , xK_x     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm .|. shiftMask, xK_Tab   ), windows W.swapMaster  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm, xK_j), windows W.swapDown  )
    , ((modm, xK_k), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm              , xK_g     ), sendMessage ToggleStruts)
    , ((modm .|. shiftMask, xK_x     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm              , xK_p     ), spawn "killall picom; picom")
    , ((0 , 0x1008ff12), spawn "pamixer -t")
    , ((0 , 0x1008ff11), spawn "pamixer -d 2")
    , ((0 , 0x1008ff13), spawn "pamixer -i 2")
    , ((0 , 0x1008ff02), spawn "xrandr --output eDP-1 --brightness 1")
    , ((0 , 0x1008ff03), spawn "xrandr --output eDP-1 --brightness 0.5")
    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. 0, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_KP_End,xK_KP_Down,xK_KP_Page_Down,xK_KP_Left,xK_KP_Begin,xK_KP_Right,xK_KP_Home,xK_KP_Up,xK_KP_Page_Up]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]


myLayout = avoidStruts $ tile ||| full
 where gaps = spacingRaw True (Border 6 6 6 6) True (Border 6 6 6 6) True 
       tile = renamed [Replace "tile"] $ gaps $ Tall 1 (3/100) (1/2)
       full = noBorders $ Full


myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "mpv"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mempty

myStartupHook = 
 spawnOnce "picom &"

main = do
 xmproc <- spawnPipe "xmobar /home/nihar/.config/xmobar/.xmobarrc"
 xmonad $ docks $ def {
    modMask = myModMask
  , workspaces = myWorkspaces
  , normalBorderColor = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , terminal = myTerminal

  , focusFollowsMouse = myFocusFollowsMouse
  , borderWidth = myBorderWidth
  , keys = myKeys
  , mouseBindings = myMouseBindings
  , layoutHook = myLayout
  , handleEventHook = myEventHook
  , startupHook = myStartupHook
  , logHook = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn xmproc }
  , manageHook = manageDocks <+> myManageHook
 }
