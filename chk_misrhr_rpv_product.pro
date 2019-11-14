FUNCTION chk_misrhr_rpv_product, $
   misrhr_rpv_product, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the input positional
   ;  parameter
   ;  misrhr_rpv_product.
   ;
   ;  ALGORITHM: This function indicates whether the value of the input
   ;  positional parameter misrhr_rpv_product is one of
   ;  [’Rho’, ’k’, ’Theta’, ’Rhoc’, ’Cost’, ’Sigmas_Rho’, ’Sigmas_k’, ’Sigmas_Theta’].
   ;
   ;  SYNTAX: rc = chk_misrhr_rpv_product(misrhr_rpv_product, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misrhr_rpv_product {STRING} [I/O]: The MISR-HR RPV product name.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
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
   ;      provided in the call. Upon exiting this function, the I/O
   ;      positional parameter misrhr_rpv_product is a valid and properly
   ;      capitalized RPV product name.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter misrhr_rpv_product is
   ;      invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misrhr_rpv_product is not
   ;      of type STRING.
   ;
   ;  *   Error 120: Input positional parameter misrhr_rpv_product is not
   ;      a scalar.
   ;
   ;  *   Error 200: The input positional parameter misrhr_rpv_product is
   ;      invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since the purpose of this function is to check the
   ;      validity of the input positional parameter misrhr_rpv_product,
   ;      all tests are performed irrespective of the setting of the input
   ;      keyword parameter DEBUG. The keywords DEBUG and EXCPT_COND are
   ;      included for consistency, and to allow reporting of the
   ;      exception condition if one is encountered.
   ;
   ;  *   NOTE 2: The input positional parameter misrhr_rpv_product is
   ;      properly capitalized on output.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misrhr_rpv_product = 'k'
   ;      IDL> rc = chk_misrhr_rpv_product(misrhr_rpv_product, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + $
   ;         ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;
   ;      IDL> misrhr_rpv_product = 'FAPAR'
   ;      IDL> rc = chk_misrhr_rpv_product(misrhr_rpv_product, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 200, excpt_cond = >Error 200 in CHK_MISRHR_RPV_PRODUCT:
   ;         Invalid misrhr_rpv_product name: must be one of
   ;         ['Rho', 'k', 'Theta', 'Rhoc', 'Cost', 'Sigmas_Rho',
   ;         'Sigmas_k', 'Sigmas_Theta'].<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–01–20: Version 0.9 — Initial release.
   ;
   ;  *   2018–02–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–28: Version 1.1 — Add logic to properly capitalize the
   ;      input positional parameter misrhr_rpv_field, recognize 3
   ;      different Sigmas types, and documentation update.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–06–20: Version 2.1.0 — Rename this function
   ;      misrhr_rpv_product, adopt revised coding and documentation
   ;      standards (in particular regarding the use of verbose and the
   ;      assignment of numeric return codes), and switch to 3-parts
   ;      version identifiers.
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
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Implement all tests: See Note 1 above.

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): misrhr_rpv_product.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misrhr_rpv_product' is not of string type:
   IF (is_string(misrhr_rpv_product) NE 1) THEN BEGIN
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter misrhr_rpv_product must be of string type.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misrhr_rpv_product' is not a scalar:
   IF (is_scalar(misrhr_rpv_product) NE 1) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': Input positional parameter misrhr_rpv_product must ' + $
         'be a scalar.'
      RETURN, error_code
   ENDIF

   ;  Ensure the variable 'misrhr_rpv_product' does not include heading or
   ;  trailing spaces:
   misrhr_rpv_product = strstr(misrhr_rpv_product)

   ;  Ensure the proper capitalization of the input positional parameter:
   misrhr_rpv_product = misrhr_rpv_product.ToLower()
   misrhr_rpv_product = misrhr_rpv_product.CapWords('_')
   IF (misrhr_rpv_product EQ 'K') THEN misrhr_rpv_product = 'k'
   IF (misrhr_rpv_product EQ 'Sigmas_K') THEN misrhr_rpv_product = 'Sigmas_k'

   ;  Define the valid values of misrhr_rpv_product:
   misrhr_rpv_products = ['Rho', 'k', 'Theta', 'Rhoc', 'Cost', $
      'Sigmas_Rho', 'Sigmas_k', 'Sigmas_Theta']

   ;  Check that the input positional parameter misrhr_rpv_product is valid:
   idx = WHERE(misrhr_rpv_product EQ misrhr_rpv_products, count)

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'misrhr_rpv_product' is invalid:
   IF (count NE 1) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ": Invalid misrhr_rpv_product name: must be one of ['Rho', " + $
         "'k', 'Theta', 'Rhoc', 'Cost', 'Sigmas_Rho', 'Sigmas_k', " + $
         "'Sigmas_Theta']."
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
