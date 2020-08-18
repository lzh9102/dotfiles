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
SwitchToEnglishLayout()
{
   en := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
   PostMessage 0x50, 0, %en%,, A
}
SwitchToLayout(n)
{
   SwitchToEnglishLayout()
   Loop % n-1 {
      Sleep 200
      Send #{Space}
   }
}
^1::SwitchToLayout(1)
^2::SwitchToLayout(2)
^3::SwitchToLayout(3)
^4::SwitchToLayout(4)

; Disable Homepage button (too easy to trigger by accident)
Browser_Home::return

; Invert screen color (mnemonic: !)
; Alt-1 is close to Alt-Tab
!1::Send ^#c

; Move window between monitors
+#l::Send +#{Right}
+#h::Send +#{Left}

; Start snipping tool
PrintScreen::Run SnippingTool.exe

; Macros on RControl
>^1::Send {Esc}o{Esc}C^v{Tab}rid:REGR{Esc}
>^2::Send Best regards,{Enter}CheHuai
>^3::Send Thanks,{Enter}CheHuai
>^Up::Send {Volume_Up}
>^Down::Send {Volume_Down}
>^Left::Send {Volume_Mute}
>^o::
   ; Cygwin terminal open in browser
   MouseClick, Right
   Send {Down}{Enter}
   return
