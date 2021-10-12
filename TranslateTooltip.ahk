#SingleInstance Force
#NoEnv

;CHANGE THESE
lang1:="en" ;Intended use: Familiar Language
lang2:="es" ;Intended use: Unfamiliar Language
;Stop Changing Stuff here pls
Menu, Tray, Tip , Tooltip Translator
Menu, Tray, NoStandard
Menu, Tray, Add, Change Hotkeys, ShowGUI
Menu, Tray, Add
Menu, Tray, Add, About, About
Menu, Tray, Add, Open Github Page, Github

gosub, HotkeyChange
return

;-------------------------------------------------------------------------------
ButtonSubmit: ; disable the old hotkey before adding a new one
   GuiControlGet, ChosenHotkey
   if ChosenHotkey
      Hotkey, %ChosenHotkey%, AutoPrimLang, Off
      Hotkey, %ChosenHotkey%, AutoPrimLang
   if ChosenHotkey2
      Hotkey, %ChosenHotkey2%, SecPrimLang, Off
      Hotkey, %ChosenHotkey2%, SecPrimLang
   if ChosenHotkey3
      Hotkey, %ChosenHotkey3%, PrimSecLang, Off
      Hotkey, %ChosenHotkey3%, PrimSecLang
   Gui, Hide
return

ShowGUI:
   Gui, Show
return

HotkeyChange:
    Gui, Add, Text,, Enter your [Auto -> Primary Language] hotkey below
    Gui, Add, Hotkey, vChosenHotkey
    Gui, Add, Text,, Enter your [Secondary Language -> Primary Language] hotkey below
    Gui, Add, Hotkey, vChosenHotkey2
    Gui, Add, Text,, Enter your [Primary Language -> Secondary Language] hotkey below
    Gui, Add, Hotkey, vChosenHotkey3
    Gui, Add, Button,, Submit
    Gui, Show
return

About:
MsgBox Tooltip Translator by Saketh Reddy
return
Github:
msgbox,262147,DECISION,Open Github Page ?
      ifmsgbox,CANCEL 
      {
         return
      }
      ifmsgbox,NO 
      {
         return
      }

run,https://github.com/SpiritSeal/AHK-Translation-Tooltip
return



AutoPrimLang: ;"IDK what language this is, but I want it in My Language" Button
    Translatinator("auto", lang1)
return
SecPrimLang:
   Translatinator(lang2, lang1)
return
PrimSecLang:
   Translatinator(lang1, lang2)
return

;TESTING
; hola mundo, torneo. Hola, me llamo Pablo.
; This is a test sentence.

+Esc::Translatinator("auto", lang1) ;"IDK what language this is, but I want it in My Language" Button
^F1::Translatinator(lang2, lang1)
^+F1::Translatinator(lang1, lang2)

Translatinator(to, from){
mousegetpos, x1, y1
x2:=x1
y2:=y1
clip:=Clipboard
Send ^c
ToolTip , % GoogleTranslate(Clipboard, to, from)
looper:=true
while x1=x2 and y1=y2{
	mousegetpos, x2, y2
}
Clipboard:=clip
ToolTip
return
}

GoogleTranslate(str, from := "auto", to := "en") {
   static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
   
   json := SendRequest(JS, str, to, from, proxy := "")
   oJSON := JS.("(" . json . ")")

   if !IsObject(oJSON[1]) {
      Loop % oJSON[0].length
         trans .= oJSON[0][A_Index - 1][0]
   }
   else {
      MainTransText := oJSON[0][0][0]
      Loop % oJSON[1].length {
         trans .= "`n+"
         obj := oJSON[1][A_Index-1][1]
         Loop % obj.length {
            txt := obj[A_Index - 1]
            trans .= (MainTransText = txt ? "" : "`n" txt)
         }
      }
   }
   if !IsObject(oJSON[1])
      MainTransText := trans := Trim(trans, ",+`n ")
   else
      trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")

   from := oJSON[2]
   trans := Trim(trans, ",+`n ")
   Return trans
}

SendRequest(JS, str, tl, sl, proxy) {
   static http
   ComObjError(false)
   if !http
   {
      http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
      ( proxy && http.SetProxy(2, proxy) )
      http.open("GET", "https://translate.google.com", true)
      http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
      http.send()
      http.WaitForResponse(-1)
   }
   http.open("POST", "https://translate.googleapis.com/translate_a/single?client=gtx"
                ; or "https://clients5.google.com/translate_a/t?client=dict-chrome-ex"
      . "&sl=" . sl . "&tl=" . tl . "&hl=" . tl
      . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1"
      . "&tk=" . JS.("tk").(str), true)

   http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
   http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
   http.send("q=" . URIEncode(str))
   http.WaitForResponse(-1)
   Return http.responsetext
}

URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)

   while code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}

GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());

      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }

      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}

CreateScriptObj() {
   static doc, JS, _JS
   if !doc {
      doc := ComObjCreate("htmlfile")
      doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
      JS := doc.parentWindow
      if (doc.documentMode < 9)
         JS.execScript()
      _JS := ObjBindMethod(JS, "eval")
   }
   Return _JS
}

Esc::Exit