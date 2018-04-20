# Windows installer definition for an Eclipse based application

# required (if not uncomment below) input parameters:
# !define APPNAME "My Application"
# !define FOLDER_NAME "my-application"
# !define CONTEXT_MENU "Open with My Application"
# !define DATE "2018-03-30"
# !define INPUT_DIR "c:\my-application"
# !define INSTALLSIZE 123000 # size (in kB)
# !define PUBLISHER "Unknown"

Outfile "${FOLDER_NAME}-${DATE}_setup.exe"
Name "${APPNAME} ${DATE}"

BrandingText " "
AddBrandingImage left 12
AddBrandingImage right 12
AddBrandingImage top 60
AddBrandingImage bottom 4

ChangeUI all "${NSISDIR}\Contrib\UIs\sdbarker_tiny.exe"

Icon "C:\Program Files (x86)\NSIS\Contrib\Graphics\Icons\orange-install.ico"
ShowInstDetails nevershow
InstProgressFlags smooth

#RequestExecutionLevel user ;no elevation needed for this test

# by the predefined $DESKTOP variable
InstallDir "$PROFILE\${FOLDER_NAME}"

#Page directory
Page instfiles

Section

  # output
  SetOutPath $INSTDIR

  # uninstall previous version
  IfFileExists $INSTDIR\uninstall.exe 0 noprevious
  ExecWait '"$INSTDIR\uninstall.exe" /S _?=$INSTDIR'
  noprevious:

  # all files
  #SetOverWrite try
  File /r "${INPUT_DIR}\*"

  # uninstall.exe
  WriteUninstaller $INSTDIR\uninstall.exe

  # shortcuts
  CreateShortcut "$SMPROGRAMS\${APPNAME}.lnk" "$INSTDIR\eclipse.exe"
  #CreateShortcut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\eclipse.exe"

  # register uninstaller
  # see http://nsis.sourceforge.net/A_simple_installer_with_start_menu_shortcut_and_uninstaller
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\eclipse.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${PUBLISHER}"
  #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
  #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
  #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
  #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
  #WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
  #WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
  # there is no option for modifying or repairing the install
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
  # set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}

  # add "Open with Eclipse" to Windows context menu (HKEY_CLASSES_ROOT\*\shell\Open with Eclipse\command)
  WriteRegStr HKCR "*\shell\${CONTEXT_MENU}\command" "" "$\"$INSTDIR\eclipse.exe$\" --launcher.openFile $\"%1$\""

  #
  Push "_shareclasses_cache"          # text to be replaced
  Push "$INSTDIR\_shareclasses_cache" # replace with
  Push "all"                          # replace all occurrences
  Push "all"                          # replace all occurrences
  Push "$INSTDIR\eclipse.ini"         # file to replace in
  Call AdvReplaceInFile

  #
  Push "configuration/"               # text to be replaced
  Push "$INSTDIR\configuration\"      # replace with
  Push "all"                          # replace all occurrences
  Push "all"                          # replace all occurrences
  Push "$INSTDIR\eclipse.ini"         # file to replace in
  Call AdvReplaceInFile

  #
  Push "jre\"                 # text to be replaced
  Push "$INSTDIR\jre\"        # replace with
  Push "all"                  # replace all occurrences
  Push "all"                  # replace all occurrences
  Push "$INSTDIR\eclipse.ini" # file to replace in
  Call AdvReplaceInFile
  
  #
  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" Personal
  Push "@user.home/Documents/" # text to be replaced
  Push "$0/"                   # replace with
  Push "all"                  # replace all occurrences
  Push "all"                  # replace all occurrences
  Push "$INSTDIR\eclipse.ini" # file to replace in
  Call AdvReplaceInFile

SectionEnd

Section "Uninstall"

  # all files but not workspace
  RMDir /r $INSTDIR\configuration
  RMDir /r $INSTDIR\dropins
  RMDir /r $INSTDIR\features
  RMDir /r $INSTDIR\jre
  RMDir /r $INSTDIR\p2
  RMDir /r $INSTDIR\plugins
  RMDir /r $INSTDIR\readme
  RMDir /r $INSTDIR\_shareclasses_cache
  Delete $INSTDIR\.eclipseproduct
  Delete $INSTDIR\artifacts.xml
  Delete $INSTDIR\eclipse.exe
  Delete $INSTDIR\eclipse.ini
  Delete $INSTDIR\eclipsec.exe

  # remove uninstaller from the registry
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"

  # remove "Open with Eclipse" from Windows context menu 
  DeleteRegKey HKCR "*\shell\${CONTEXT_MENU}"

  # remove shortcuts
  Delete "$SMPROGRAMS\${APPNAME}.lnk"
  Delete "$DESKTOP\${APPNAME}.lnk"

  # remove uninstaller
  Delete $INSTDIR\uninstall.exe

  # remove install directory if empty
  # see http://nsis.sourceforge.net/Delete_dir_only_if_empty
  StrCpy $0 "$INSTDIR"
  Call un.DeleteDirIfEmpty

SectionEnd

Function un.DeleteDirIfEmpty
  FindFirst $R0 $R1 "$0\*.*"
  strcmp $R1 "." 0 NoDelete
   FindNext $R0 $R1
   strcmp $R1 ".." 0 NoDelete
    ClearErrors
    FindNext $R0 $R1
    IfErrors 0 NoDelete
     FindClose $R0
     Sleep 1000
     RMDir "$0"
  NoDelete:
   FindClose $R0
FunctionEnd


# http://nsis.sourceforge.net/More_advanced_replace_text_in_file
Function AdvReplaceInFile
	Exch $0 ;file to replace in
	Exch
	Exch $1 ;number to replace after
	Exch
	Exch 2
	Exch $2 ;replace and onwards
	Exch 2
	Exch 3
	Exch $3 ;replace with
	Exch 3
	Exch 4
	Exch $4 ;to replace
	Exch 4
	Push $5 ;minus count
	Push $6 ;universal
	Push $7 ;end string
	Push $8 ;left string
	Push $9 ;right string
	Push $R0 ;file1
	Push $R1 ;file2
	Push $R2 ;read
	Push $R3 ;universal
	Push $R4 ;count (onwards)
	Push $R5 ;count (after)
	Push $R6 ;temp file name
	 
	  GetTempFileName $R6
	  FileOpen $R1 $0 r ;file to search in
	  FileOpen $R0 $R6 w ;temp file
	   StrLen $R3 $4
	   StrCpy $R4 -1
	   StrCpy $R5 -1
	 
	loop_read:
	 ClearErrors
	 FileRead $R1 $R2 ;read line
	 IfErrors exit
	 
	   StrCpy $5 0
	   StrCpy $7 $R2
	 
	loop_filter:
	   IntOp $5 $5 - 1
	   StrCpy $6 $7 $R3 $5 ;search
	   StrCmp $6 "" file_write1
	   StrCmp $6 $4 0 loop_filter
	 
	StrCpy $8 $7 $5 ;left part
	IntOp $6 $5 + $R3
	IntCmp $6 0 is0 not0
	is0:
	StrCpy $9 ""
	Goto done
	not0:
	StrCpy $9 $7 "" $6 ;right part
	done:
	StrCpy $7 $8$3$9 ;re-join
	 
	IntOp $R4 $R4 + 1
	StrCmp $2 all loop_filter
	StrCmp $R4 $2 0 file_write2
	IntOp $R4 $R4 - 1
	 
	IntOp $R5 $R5 + 1
	StrCmp $1 all loop_filter
	StrCmp $R5 $1 0 file_write1
	IntOp $R5 $R5 - 1
	Goto file_write2
	 
	file_write1:
	 FileWrite $R0 $7 ;write modified line
	Goto loop_read
	 
	file_write2:
	 FileWrite $R0 $R2 ;write unmodified line
	Goto loop_read
	 
	exit:
	  FileClose $R0
	  FileClose $R1
	 
	   SetDetailsPrint none
	  Delete $0
	  Rename $R6 $0
	  Delete $R6
	   SetDetailsPrint lastused
	 
	Pop $R6
	Pop $R5
	Pop $R4
	Pop $R3
	Pop $R2
	Pop $R1
	Pop $R0
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	;These values are stored in the stack in the reverse order they were pushed
	Pop $0
	Pop $1
	Pop $2
	Pop $3
	Pop $4
FunctionEnd
