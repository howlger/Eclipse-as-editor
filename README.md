# Eclipse as Editor

This Ant build script creates an Eclipse distribution for Windows which can be
used as a more or less fast starting editor, e. g. as an alternative to
[Notepad++](https://notepad-plus-plus.org/) or to [ConTEXT](http://www.contexteditor.org).

##### Requirements to build _Eclipse as Editor_:
*   [Apache Ant](https://ant.apache.org/) to run the build script `build.xml`

##### Expected result:
*   `eclipse-as-editor-<date>_setup.exe` - Windows installer (via [NSIS](http://nsis.sourceforge.net/Main_Page)) for _Eclipse as Editor_:
    - [Eclipse platform 4.8 **integration build**](http://download.eclipse.org/eclipse/downloads/#4.8_Integration_Builds)
    - embedded JRE: [OpenJDK 10 with Eclipse OpenJ9 **nightly build**](https://adoptopenjdk.net/nightly.html?variant=openjdk10-openj9) (so Java does not have to be installed separately to run _Eclipse as Editor_)
    - [Eclipse Marketplace Client](http://www.eclipse.org/mpc/)
    - [Eclipse TM4E - TextMate support in the Eclipse IDE](https://eclipse.org/tm4e)
    - TextMate language pack (will be built within the build script)
    - [Eclipse XML Editors and Tools](https://marketplace.eclipse.org/content/eclipse-xml-editors-and-tools-0)
    - [Eclipse JavaScript Development Tools (JSDT)](https://www.eclipse.org/webtools/jsdt/)
    - [QuickImage](http://marketplace.eclipse.org/content/quickimage)
    - [AnyEdit Tools](http://marketplace.eclipse.org/content/anyedit-tools)
    - [Eclipse Mylyn](http://www.eclipse.org/mylyn/)
    - [Timekeeper for Eclipse](http://marketplace.eclipse.org/content/timekeeper-eclipse)
    - [Batch Editor](http://marketplace.eclipse.org/content/batch-editor)
    - [Bash Editor](http://marketplace.eclipse.org/content/bash-editor)
    - [Java Hex Editor](https://marketplace.eclipse.org/content/java-hex-editor)
    - [YEdit](https://marketplace.eclipse.org/content/yedit)
