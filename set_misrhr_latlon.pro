FUNCTION set_misrhr_latlon, $
   misr_path, $
   misr_block, $
   latitudes, $
   longitudes, $
   OUT_FOLDER = out_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function calculates, returns and saves the
   ;  geographical location (latitude and longitude) of each pixel in a
   ;  MISR-HR product for the specified MISR PATH and BLOCK numbers. The
   ;  results are saved in a plain ASCII file as well as in a SAVE file,
   ;  and both are written in the default folder defined by the function
   ;  set_roots_vers.pro or in the output directory specified by the
   ;  optional input keyword parameter OUT_FOLDER.
   ;
   ;  ALGORITHM: This function relies on the MISR TOOLKIT function
   ;  MTK_BLS_TO_LATLON to compute the latitude and longitude of every
   ;  pixel in the specified PATH and BLOCK.
   ;
   ;  SYNTAX: rc = set_misrhr_latlon(misr_path, misr_block,$
   ;  latitudes, longitudes, OUT_FOLDER = out_folder,$
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_block {INT} [I]: The selected MISR BLOCK number.
   ;
   ;  *   latitudes {DOUBLE array} [O]: The array of pixel latitudes,
   ;      dimensioned
   ;      n_lines = 512 by n_samples = 2048.
   ;
   ;  *   longitudes {DOUBLE array} [O]: The array of pixel longitudes,
   ;      dimensioned
   ;      n_lines = 512 by n_samples = 2048.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   OUT_FOLDER = out_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the output file(s).
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
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. This function saves 2 files in the folder
   ;      root_dirs[3] + ’Pxxx_Bzzz/’: the arrays of pixel latitudes and
   ;      longitudes in a plain ASCII text file as well as in an IDL SAVE
   ;      file named
   ;      Lat-Lon_Pxxx_Bzzz_[Toolkit_version]_[creation_date].txt and
   ;      Lat-Lon_Pxxx_Bzzz_[Toolkit_version]_[creation_date].sav,
   ;      respectively.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered. The output files are not created, if the optional
   ;      input keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: Positional parameter misr_block is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 400: The output folder out_fpath is unwritable.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_dir.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = set_misrhr_latlon(168, 112, latitudes, longitudes, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      The IDL SAVE file containing the latitudes and the longitudes
   ;      of all MISR-HR pixels has been saved in
   ;      ~/MISR_HR/Outcomes/P168_B112/Lat-Lon_P168_B112_1.4.5_2019-11-14.sav.
   ;
   ;      [To confirm the existence of the output files:]
   ;
   ;      IDL> rc = set_roots_vers(root_dirs, versions)
   ;      IDL> loc = root_dirs[3] + 'P168_B112/'
   ;      IDL> SPAWN, 'ls ' + loc
   ;      Lat-Lon_P168_B112_1.4.5_2019-11-14.sav
   ;      Lat-Lon_P168_B112_1.4.5_2019-11-14.txt
   ;
   ;      [To explore the content of the SAVE file:]
   ;
   ;      IDL> sf = loc + '/Lat-Lon_P168_B112_1.4.5_2019-11-14.sav'
   ;      IDL> sObj = OBJ_NEW('IDL_Savefile', sf)
   ;      IDL> sContents = sObj->Contents()
   ;      IDL> PRINT, sContents.N_VAR, '   ', sObj->Names()
   ;      4    LATITUDES LONGITUDES N_LINES N_SAMPLES
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–08–21: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–16: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–04–17: Version 1.2 — Documentation update and bug fix: set
   ;      and add the current date to the output filenames.
   ;
   ;  *   2018–05–14: Version 1.3 — Update this function to use the
   ;      revised version of
   ;      is_writable.pro.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–03: Version 1.6 — Documentation update.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–04–11: Version 2.01 — Update the code to call
   ;      set_roots_vers.pro instead of the deprecated function
   ;      set_root_dirs.pro.
   ;
   ;  *   2019–06–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–11–14: Version 2.1.1 — Minor update to the name of the
   ;      output files.
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
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   ;  Set the spatial resolution, number of lines and number of samples in
   ;  MISR-HR products:
   resolution = 275.0
   n_lines = 512
   n_samples = 2048

   ;  Define the output variables:
   latitudes = DBLARR(n_lines, n_samples)
   longitudes = DBLARR(n_lines, n_samples)

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_path, misr_block, ' + $
            'latitudes, longitudes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid MISR Path:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid MISR Block:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the string version of the MISR Path and Block numbers:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   rc = block2str(misr_block, misr_block_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pb = misr_path_str + '_' + misr_block_str

   ;  Get the current date:
   date = today(FMT = 'ymd')

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

   ;  Get the MISR Toolkit version:
   toolkit = MTK_VERSION()

   ;  Set the directory address of the folder containing the output files:
   IF (KEYWORD_SET(out_folder)) THEN BEGIN
      out_fpath = out_folder
   ENDIF ELSE BEGIN
      out_fpath = root_dirs[3] + pb + PATH_SEP()
   ENDELSE
   rc = force_path_sep(out_fpath, DEBUG = debug, EXCPT_COND = excpt_cond)

   ;  Create the output directory 'out_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
   res = is_writable_dir(out_fpath, /CREATE)
   IF (debug AND (res NE 1)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The directory out_fpath is unwritable.'
      RETURN, error_code
   ENDIF

   ;  Generate the specification of the Lat-Lon file:
   latlon_fname = 'Lat-Lon_' + pb + '_' + toolkit + '_' + date
   latlon_fspec = out_fpath + latlon_fname + '.txt'

   ;  Open this file:
   fmt1 = '(A6, 2X, A6, 2X, A15, 2X, A15)'
   fmt2 = '(I6, 2X, I6, 2X, D15.8, 2X, D15.8)'
   OPENW, latlon_unit, latlon_fspec, /GET_LUN
   PRINTF, latlon_unit, 'Latitudes and longitudes of the MISR-HR pixels ' + $
      'for Path ' + strstr(misr_path) + ' and Block ' + strstr(misr_block) + '.'
   PRINTF, latlon_unit
   PRINTF, latlon_unit, 'Line', 'Sample', 'Latitude', 'Longitude', FORMAT = fmt1

   ;  Loop over the lines:
   FOR i = 0, n_lines - 1 DO BEGIN

   ;  Loop over the samples:
      FOR j = 0, n_samples - 1 DO BEGIN
         res = MTK_BLS_TO_LATLON(misr_path, resolution, misr_block, $
            FLOAT(i), FLOAT(j), lat, lon)
         latitudes[i, j] = lat
         longitudes[i, j] = lon
         PRINTF, latlon_unit, i, j, lat, lon, FORMAT = fmt2
      ENDFOR
   ENDFOR

   FREE_LUN, latlon_unit
   CLOSE, latlon_unit

   ;  Save the latitudes and longitudes for easy subsequent retrieval:
   latlon_fspec = out_fpath + latlon_fname + '.sav'
   SAVE, n_lines, n_samples, latitudes, longitudes, FILENAME = latlon_fspec

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The IDL SAVE file containing the latitudes and the ' + $
         'longitudes of all MISR-HR pixels has been saved in ' + $
         latlon_fspec + '.'
   ENDIF
   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
