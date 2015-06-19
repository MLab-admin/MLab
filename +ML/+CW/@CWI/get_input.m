function get_input(this, varargin)
%ML.CW.CWI/get_input Get input
%   ML.CW.CWI/get_input(I) asks for a the value of the input element at
%   position I in the grid.
%
%   Note: This method is related to <a href="matlab:help M.CW.CWI.input">ML.CW.CWI/input</a> and should not be 
%   called directly by the end user of the class.
%
%   See also ML.CW.CWI, ML.CW.CWI/input
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.get_input');">ML.doc</a>

% --- Input
in = ML.Input;
in.elm = @isnumeric;
in = +in;

% --- Get input
fprintf('Please enter the new input for ''%s'': [Ctrl+C to skip]\n', this.elms{in.elm}.desc);
this.elms{in.elm}.value = input('?> ', 's');
    
% --- Re-print
clc
this.print;

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help.
%   1.0     (2015/04/06): Initial version.
%
%! To do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>