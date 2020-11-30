; My Custom Windows Hotkeys
;
; To use this script, install AutoHotKey and create a shortcut of this script in
; C:\Users\[User Name]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
;
; Modifier Key Prefixes
;
;    # Win
;    ^ Control
;    ! Alt
;    + Shift

#MaxHotkeysPerInterval 200
SendMode Input

; Navigation Keys
!+h::Send  {Left}
!+j::Send  {Down}
!+k::Send  {Up}
!+l::Send  {Right}
!+e::Send  {End}
!+a::Send  {Home}
!+f::Send  ^{Right}
!+b::Send  ^{Left}
!+n::Send  {PgDn}
!+p::Send  {PgUp}
!+w::Send  ^{Backspace}
!+d::Send  {Delete}
!+^d::Send ^{Delete}

; Navigation keys with right Alt
>!u::Send ^{Backspace}
>!h::Send {Backspace}
>!d::Send {Delete}
>!j::Send {Enter}
>!f::Send ^{Right}
>!b::Send ^{Left}

; Send Esc
^[::Send {Esc}

; Disable Shift+Alt (Windows shortcut to trigger IME switch)
!Shift::return
+Alt::return

; Prevent triggering full-width/half-width toggle when pressing Shift+Space
+Space::Send {Space}

; Quickly switch between keyboard layouts
; Reference: https://autohotkey.com/board/topic/70019-keyboard-layout-switcher-for-many-layouts/
SwitchToLayout(layout_id)
{
	layout := DllCall("LoadKeyboardLayout", "Str", layout_id, "Int", 1)
   PostMessage 0x50, 0, %layout%,, A
}
!+1::SwitchToLayout("00000409") ; en
!+2::SwitchToLayout("00000404") ; zh_TW
!+3::SwitchToLayout("00000411") ; ja
!+4::SwitchToLayout("00000412") ; ko

; Disable Homepage button (too easy to trigger by accident)
Browser_Home::return

; Invert screen color (mnemonic: !)
; Alt-1 is close to Alt-Tab
!1::Send ^#c

; Window Manipulation
+#l::Send +#{Right}
+#h::Send +#{Left}
+#k::WinMaximize A
+#j::WinRestore A

; Snip & Sketch
PrintScreen::Send #+s

; On Logitech K810, pressing F4 without holding Fn sends Ctrl+Win+Backspace.
; Map Ctrl+Win+Alt+Backspace => Alt+F4 to enable closing window with Alt+F4 gesture
^#!Backspace::
   ; Wait for Alt and Ctrl to be released before sending Alt+F4.
   ; Without waiting, some modifier keys would be stucked at pressed-down state.
   KeyWait Alt
   KeyWait Control
   Send !{F4}
   return
