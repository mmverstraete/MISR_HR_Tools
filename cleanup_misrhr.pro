FUNCTION cleanup_misrhr, $
   MISR_PATH = misr_path, $
   MISR_BLOCK = misr_block, $
   MISRHR_FOLDER = misrhr_folder, $
   MISRHR_VERSION = misrhr_version, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function optionally deletes some or all files located
   ;  in subfolders of the Temp directory that contains intermediary
   ;  results derived during the MISR-HR processing.
   ;
   ;  ALGORITHM: This function inspects and optionally deletes the
   ;  contents of the subfolders Scripts, SurfaceBRF and SurfaceGeom of
   ;  the Temp subfolders generated during the processing of MISR-HR
   ;  products for a given PATH and BLOCK. These folders contain
   ;  intermediary results that may be useful to resume processing without
   ;  having to restart from scratch, but are otherwise unnecessary for
   ;  further analyses.
   ;
   ;  *   If the optional input keyword parameter MISR_PATH is set, only
   ;      subfolders of that PATH are visited.
   ;
   ;  *   If the optional input keyword parameter MISR_BLOCK is set, only
   ;      subfolders of that BLOCK are visited.
   ;
   ;  *   If neither MISR_PATH nor MISR_BLOCK are set, all available
   ;      combinations of PATH and BLOCK are inspected.
   ;
   ;  In all cases, if regular files are detected in those subdirectories,
   ;  the function reports on the number of files found in each applicable
   ;  directory and requests explicit authorization to delete those files.
   ;
   ;  SYNTAX: rc = cleanup_misrhr(MISR_PATH = misr_path, $
   ;  MISR_BLOCK = misr_block, $
   ;  MISRHR_FOLDER = misrhr_folder, MISRHR_VERSION = misrhr_version, $
   ;  LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   MISR_PATH = misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   MISR_BLOCK = misr_block {INT} [I]: The selected MISR BLOCK
   ;      number.
   ;
   ;  *   MISRHR_FOLDER = misrhr_folder {STRING} [I] (Default value: Set
   ;      by the
   ;      function set_roots_vers.pro): The directory address of the
   ;      folder containing the MISR-HR results.
   ;
   ;  *   MISRHR_VERSION = misrhr_version {STRING} [I] (Default value: Set
   ;      by the function
   ;      set_roots_vers.pro): The MISR-HR version identifier to use
   ;      instead of the default value.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I] (Default value: Set by the
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the processing log.
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) outputting messages on the console:
   ;
   ;      -   If verbose > 0, messages inform the user about progress in
   ;          the execution of time-consuming routines, or the location of
   ;          output files (e.g., log, map, plot, etc.);
   ;
   ;      -   If verbose > 1, messages record entering and exiting the
   ;          routine; and
   ;
   ;      -   If verbose > 2, messages provide additional information
   ;          about intermediary results.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The files containing the intermediary
   ;      results have been deleted as per explicit request.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The The files containing the intermediary results may
   ;      not have been deleted.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: The input keyword parameter misr_mode is invalid.
   ;
   ;  *   Error 110: The input keyword parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input keyword parameter misrhr_folder does not
   ;      exist or is not a folder name.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters misrhr_folder, log_folder
   ;      is not specified.
   ;
   ;  *   Error 300: There are no PATH folders to process in the folder
   ;      misrhr_fpath.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   first_char.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: WARNING: This function is designed to delete specific
   ;      files. Use with caution, and authorize the deletions for each
   ;      folder individually, as these deletions cannot be undone.
   ;
   ;  *   NOTE 2: This function will only work correctly if the folders
   ;      and subfolders of the MISR-HR output directory follow the
   ;      hierarchical structure recommended in the documentation.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_block = 112
   ;      IDL> rc = cleanup_misrhr(MISR_PATH = misr_path, MISR_BLOCK = misr_block, /LOG_IT, /DEBUG, EXCPT_COND = excpt_cond)
   ;      Processing Path folder /Volumes/MISR-HR/P168
   ;      Path folder /Volumes/MISR-HR/P168 contains 7 Block folders.
   ;         Processing Block folder /Volumes/MISR-HR/P168/B112
   ;         Block folder /Volumes/MISR-HR/P168/B112 contains 1 Temp folder.
   ;      Ready to delete 830 files matching the pattern /Volumes/MISR-HR/P168/B112/Temp/Scripts/
   ;      Go ahead (Y/N)? n
   ;      Skipped deleting the files /Volumes/MISR-HR/P168/B112/Temp/Scripts/*
   ;      Ready to delete 14940 files matching the pattern /Volumes/MISR-HR/P168/B112/Temp/SurfaceBRF/
   ;      Go ahead (Y/N)? n
   ;      Skipped deleting the files /Volumes/MISR-HR/P168/B112/Temp/SurfaceBRF/*
   ;      Ready to delete 415 files matching the pattern /Volumes/MISR-HR/P168/B112/Temp/SurfaceGeom/
   ;      Go ahead (Y/N)? n
   ;      Skipped deleting the files /Volumes/MISR-HR/P168/B112/Temp/SurfaceGeom/*
   ;      Processing Path folder /Volumes/MISR-HR/P168_B112
   ;      Path folder /Volumes/MISR-HR/P168_B112 contains 0 Block folders.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–05–04: Version 1.0 — Initial release.
   ;
   ;  *   2019–05–05: Version 2.00 — Initial public release.
   ;
   ;  *   2019–06–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–11–14: Version 2.1.1 — Add the example above and minor
   ;      update to the documentation.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in its entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (~KEYWORD_SET(misr_path)) THEN misr_path = 0
   IF (~KEYWORD_SET(misr_block)) THEN misr_block = 0
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Exit the program with an error message if the input keyword parameter
   ;  'misr_path' is defined and invalid:
      IF (KEYWORD_SET(misr_path)) THEN BEGIN
         rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 0) THEN BEGIN
            error_code = 100
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF

   ;  Exit the program with an error message if the input keyword parameter
   ;  'misr_block' is defined and invalid:
      IF (KEYWORD_SET(misr_block)) THEN BEGIN
         rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 0) THEN BEGIN
            error_code = 110
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF

   ;  Exit the program with an error message if the input keyword parameter
   ;  'misrhr_folder' is defined and not a valid folder name:
      IF (KEYWORD_SET(misrhr_folder)) THEN BEGIN
         res = FILE_INFO(misrhr_folder)
         IF ((res.EXISTS NE 1) OR (res.DIRECTORY NE 1)) THEN BEGIN
            error_code = 120
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': The optional keyword parameter misrhr_folder does not ' +   $
               'exist or is not a folder name.'
            RETURN, error_code
         ENDIF
      ENDIF
   ENDIF

   ;  Set the default folders and version identifiers of the MISR and
   ;  MISR-HR files on this computer, and return to the calling routine if
   ;  there is an internal error, but not if the computer is unrecognized, as
   ;  root addresses can be overridden by input keyword parameters:
   rc_roots = set_roots_vers(root_dirs, versions, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc_roots GE 100)) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (~KEYWORD_SET(misrhr_version)) THEN misrhr_version = versions[8]

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Generate the long string version of the MISR Path number, whether it is
   ;  specified explicitly or not:
   IF (KEYWORD_SET(misr_path)) THEN BEGIN
      rc = path2str(misr_path, misr_path_str, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE BEGIN
      misr_path_str = 'P000'
   ENDELSE

   ;  Generate the long string version of the MISR Block number, whether it is
   ;  specified explicitly or not:
   IF (KEYWORD_SET(misr_block)) THEN BEGIN
      rc = block2str(misr_block, misr_block_str, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE BEGIN
      misr_block_str = 'B000'
   ENDELSE

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(misrhr_folder) OR $
         (log_it AND (~KEYWORD_SET(log_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + '. And at least one of the optional input ' + $
            'keyword parameters misrhr_folder, log_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the root directory address of the MISR-HR output folder if it has not
   ;  been set previously:
   IF (KEYWORD_SET(misrhr_folder)) THEN BEGIN
      rc = force_path_sep(misrhr_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      misrhr_fpath = misrhr_folder
   ENDIF ELSE BEGIN
      misrhr_fpath = root_dirs[2]
   ENDELSE

   ;  Retrieve the list of Path folders within this MISR-HR root folder:
   pattern = misrhr_fpath + 'P*' + PATH_SEP()
   path_folders = FILE_SEARCH(pattern, /TEST_DIRECTORY, $
      COUNT = n_path_folders)

   ;  Exit the program if no Path folders are found in this root folder:
   IF (n_path_folders EQ 0) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': There are no Path folders to process in the folder ' + $
         misrhr_fpath
      RETURN, error_code
   ENDIF

   ;  Loop over the existing Path folders:
   line = ''
   FOR pf = 0, n_path_folders - 1 DO BEGIN
      pfolder = path_folders[pf]

   ;  Extract the Path number from the folder name, and check whether it
   ;  needs to be processed:
      mp = pfolder.Extract('P[0-9]{3}')
      IF ((misr_path EQ 0) OR $
         ((misr_path GT 0) AND (mp EQ misr_path_str))) THEN BEGIN
         PRINT, 'Processing Path folder ' + pfolder

   ;  Retrieve the list of subdirectories within this directory:
         pattern = pfolder + PATH_SEP() + 'B*' + PATH_SEP()
         block_folders = FILE_SEARCH(pattern, /TEST_DIRECTORY, $
            COUNT = n_block_folders)
         PRINT, 'Path folder ' + pfolder + ' contains ' + $
            strstr(n_block_folders) + ' Block folders.'

   ;  Loop over the Block folders:
         IF (n_block_folders GT 0) THEN BEGIN
            FOR bf = 0, n_block_folders - 1 DO BEGIN
               bfolder = block_folders[bf]

   ;  Extract the Block number from the folder name, and check whether it
   ;  needs to be processed:
               mb = bfolder.Extract('B[0-9]{3}')
               IF ((misr_block EQ 0) OR $
                  ((misr_block GT 0) AND (mb EQ misr_block_str))) THEN BEGIN
                  PRINT, '   Processing Block folder ' + bfolder

   ;  Determine whether this Block folder contains a 'Temp' subdirectory:
                  pattern = bfolder + PATH_SEP() + 'Temp' + PATH_SEP()
                  temp_folder = FILE_SEARCH(pattern, /TEST_DIRECTORY, $
                     COUNT = n_temp_folders)
                  PRINT, '   Block folder ' + bfolder + ' contains ' + $
                     strstr(n_temp_folders) + ' Temp folder.'

   ;  If a Temp folder exists, delete the contents of its Scripts subfolder:
                  patt1 = pattern + 'Scripts' + PATH_SEP()
                  d1 = FILE_INFO(patt1)
                  IF ((d1.EXISTS EQ 1) AND (d1.DIRECTORY EQ 1)) THEN BEGIN
                     patt11 = patt1 + '*'
                     f1 = FILE_SEARCH(patt11, /TEST_REGULAR, $
                        COUNT = n_temp_scripts_files)
                     IF (n_temp_scripts_files GT 0) THEN BEGIN
                        PRINT, 'Ready to delete ' + $
                           strstr(n_temp_scripts_files) + $
                           ' files matching the pattern ' + patt1
                        READ, line, PROMPT = 'Go ahead (Y/N)? '
                        IF (STRUPCASE(first_char(strstr(line))) EQ 'Y') $
                           THEN BEGIN
                           SPAWN, 'rm ' + patt11
                           PRINT, 'Deleted the files ' + patt11
                        ENDIF ELSE BEGIN
                           PRINT, 'Skipped deleting the files ' + patt11
                        ENDELSE
                     ENDIF ELSE BEGIN
                        PRINT, 'Nothing to delete in ' + patt1 + '.'
                     ENDELSE
                  ENDIF

   ;  If a Temp folder exists, delete the contents of its SurfaceBRF subfolder:
                  patt2 = pattern + 'SurfaceBRF' + PATH_SEP()
                  d2 = FILE_INFO(patt2)
                  IF ((d2.EXISTS EQ 1) AND (d2.DIRECTORY EQ 1)) THEN BEGIN
                     patt22 = patt2 + '*'
                     f2 = FILE_SEARCH(patt22, /TEST_REGULAR, $
                        COUNT = n_temp_sfcbrf_files)
                     IF (n_temp_sfcbrf_files GT 0) THEN BEGIN
                        PRINT, 'Ready to delete ' + $
                           strstr(n_temp_sfcbrf_files) + $
                           ' files matching the pattern ' + patt2
                        READ, line, PROMPT = 'Go ahead (Y/N)? '
                        IF (STRUPCASE(first_char(strstr(line))) EQ 'Y') $
                           THEN BEGIN
                           SPAWN, 'for f in ' + patt22 + '; do rm "$f"; done'
                           PRINT, 'Deleted the files ' + patt22
                        ENDIF ELSE BEGIN
                           PRINT, 'Skipped deleting the files ' + patt22
                        ENDELSE
                     ENDIF ELSE BEGIN
                        PRINT, 'Nothing to delete in ' + patt2 + '.'
                     ENDELSE
                  ENDIF

   ;  If a Temp folder exists, delete the contents of its SurfaceGeom subfolder:
                  patt3 = pattern + 'SurfaceGeom' + PATH_SEP()
                  d3 = FILE_INFO(patt3)
                  IF ((d3.EXISTS EQ 1) AND (d3.DIRECTORY EQ 1)) THEN BEGIN
                     patt33 = patt3 + '*'
                     f3 = FILE_SEARCH(patt33, /TEST_REGULAR, $
                        COUNT = n_temp_sfcgeo_files)
                     IF (n_temp_sfcgeo_files GT 0) THEN BEGIN
                        PRINT, 'Ready to delete ' + $
                           strstr(n_temp_sfcgeo_files) + $
                           ' files matching the pattern ' + patt3
                        READ, line, PROMPT = 'Go ahead (Y/N)? '
                        IF (STRUPCASE(first_char(strstr(line))) EQ 'Y') $
                           THEN BEGIN
                           SPAWN, 'rm ' + patt33
                           PRINT, 'Deleted the files ' + patt33
                        ENDIF ELSE BEGIN
                           PRINT, 'Skipped deleting the files ' + patt33
                        ENDELSE
                     ENDIF ELSE BEGIN
                        PRINT, 'Nothing to delete in ' + patt3 + '.'
                     ENDELSE
                  ENDIF
               ENDIF
            ENDFOR
         ENDIF
      ENDIF
   ENDFOR

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
