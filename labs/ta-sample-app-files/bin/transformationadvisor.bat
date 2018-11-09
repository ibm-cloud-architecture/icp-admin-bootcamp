@REM transformationadvisor launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM TRANSFORMATIONADVISOR_config.txt found in the TRANSFORMATIONADVISOR_HOME.
@setlocal enabledelayedexpansion

@echo off

if "%TRANSFORMATIONADVISOR_HOME%"=="" set "TRANSFORMATIONADVISOR_HOME=%~dp0\\.."

set ta_working_dir=%TRANSFORMATIONADVISOR_HOME%

set "APP_LIB_DIR=%TRANSFORMATIONADVISOR_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%TRANSFORMATIONADVISOR_HOME%\TRANSFORMATIONADVISOR_config.txt"

set CFG_OPTS=
if exist "%CFG_FILE%" (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
    
  )
)

rem We use the value of the JAVACMD environment variable if defined
set JAVA_HOME=%TRANSFORMATIONADVISOR_HOME%\jre
echo %JAVACMD%
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running transformationadvisor.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set "JAVA_OPTS=-Dta_working_dir=%ta_working_dir%"
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=


set "APP_CLASSPATH=%APP_LIB_DIR%\transformationadvisor.transformationadvisor-2.1.jar;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wsadmin_1.0.0.jar;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.logmanager_1.0.0.jar;%APP_LIB_DIR%\org.apache.log4j_1.2.15.v201012070815.jar;%APP_LIB_DIR%\org.eclipse.osgi_3.11.0.jar;%APP_LIB_DIR%\org.eclipse.core.runtime_3.10.0.v20140318-2214.jar;%APP_LIB_DIR%\commons-lang3-3.3.2.jar;%APP_LIB_DIR%\com.ibm.issw.migr.wcmt_1.0.0.jar;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig_1.0.0.jar;%APP_LIB_DIR%\com.ibm.issw.migr.wcmt.was_1.0.0.jar;%APP_LIB_DIR%\binaryAppScanner.jar;%APP_LIB_DIR%\org.eclipse.equinox.common_3.6.200.v20130402-1505.jar;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.commons_1.0.0.jar;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.liberty_1.0.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.11.11.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.10.jar;%APP_LIB_DIR%\commons-io.commons-io-2.5.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.11-1.0.6.jar;%APP_LIB_DIR%\org.json4s.json4s-jackson_2.11-3.4.2.jar;%APP_LIB_DIR%\org.json4s.json4s-core_2.11-3.4.2.jar;%APP_LIB_DIR%\org.json4s.json4s-ast_2.11-3.4.2.jar;%APP_LIB_DIR%\org.json4s.json4s-scalap_2.11-3.4.2.jar;%APP_LIB_DIR%\com.thoughtworks.paranamer.paranamer-2.8.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.6.7.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.6.7.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-scala_2.11-2.6.7.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.11.11.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.6.7.jar;%APP_LIB_DIR%\com.fasterxml.jackson.module.jackson-module-paranamer-2.6.7.jar;%APP_LIB_DIR%\org.fusesource.jansi.jansi-1.17.1.jar;%APP_LIB_DIR%\de.vandermeer.asciitable-j7-1.0.1.jar;%APP_LIB_DIR%\de.vandermeer.asciilist-j7-1.0.0.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.4.jar;%APP_LIB_DIR%\javax.inject.javax.inject-1.jar;%APP_LIB_DIR%\com.googlecode.json-simple.json-simple-1.1.1.jar;%APP_LIB_DIR%\junit.junit-4.10.jar;%APP_LIB_DIR%\org.hamcrest.hamcrest-core-1.1.jar;%APP_LIB_DIR%\com.squareup.okhttp3.okhttp-3.8.1.jar;%APP_LIB_DIR%\com.squareup.okio.okio-1.13.0.jar;%APP_LIB_DIR%\org.rogach.scallop_2.11-3.0.3.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.2.3.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.2.3.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.25.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging_2.11-3.7.2.jar;%APP_LIB_DIR%\org.scalactic.scalactic_2.11-3.0.1.jar"
set "APP_MAIN_CLASS=com.ibm.liftandshift.Main"

:param_loop
call set _PARAM1=%%1
set "_ARGUMENT=%~1"

if ["!_PARAM1!"]==[""] goto param_afterloop


rem ignore arguments that do not start with '-'
if "%_ARGUMENT:~0,1%"=="-" goto param_java_check
set _APP_ARGS=!_APP_ARGS! !_PARAM1!
shift
goto param_loop

:param_java_check
if "!_ARGUMENT:~0,2!"=="-J" (
  rem strip -J prefix
  set _JAVA_PARAMS=!_JAVA_PARAMS! !_ARGUMENT:~2!
  shift
  goto param_loop
)

if "!_ARGUMENT:~0,2!"=="-D" (
  rem test if this was double-quoted property "-Dprop=42"
  for /F "delims== tokens=1,*" %%G in ("!_ARGUMENT!") DO (
    if not ["%%H"] == [""] (
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
    ) else if [%2] neq [] (
      rem it was a normal property: -Dprop=42 or -Drop="42"
      call set _PARAM1=%%1=%%2
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      shift
    )
  )
) else (
  if "!_ARGUMENT!"=="-main" (
    call set CUSTOM_MAIN_CLASS=%%2
    shift
  ) else (
    if "!_ARGUMENT!"=="-w" (
      set APP_CLASSPATH=%APP_CLASSPATH%;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig.was_1.0.0.jar
    )
    if "!_ARGUMENT!"=="--web-logic-config-file" (
      set APP_CLASSPATH=%APP_CLASSPATH%;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig.wls_1.0.0.jar
    )
    if "!_ARGUMENT!"=="-l" (
      set APP_CLASSPATH=%APP_CLASSPATH%;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig.wls_1.0.0.jar
    )
    if "!_ARGUMENT!"=="--jboss-config-dir" (
         set APP_CLASSPATH=%APP_CLASSPATH%;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig.jboss_1.0.0.jar
    )
    if "!_ARGUMENT!"=="-b" (
         set APP_CLASSPATH=%APP_CLASSPATH%;%APP_LIB_DIR%\com.ibm.issw.migr.osgi.wasconfig.jboss_1.0.0.jar
    )
    set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  )
)
shift
goto param_loop
:param_afterloop

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!
:run


if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

set "ta_working_dir=%~dp0\\.."
rem Call the application and pass all arguments unchanged.
start cmd.exe @cmd /k "mode con: cols=150 lines=30 && "%_JAVACMD%" !_JAVA_OPTS! !TRANSFORMATIONADVISOR_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!"
@endlocal


:end

exit /B %ERRORLEVEL%
