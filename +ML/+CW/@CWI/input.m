function input(this, varargin)
%ML.CW.CWI/input Input element
%   ML.CW.CWI/input(I, J, DESC) adds a clickable input element at position 
%   (I,J) in the grid. The description is specified by the string DESC and
%   can be removed if an empty string is passed.
%
%   ML.CW.CWI/input(..., 'value', V) specifies the initial value. V can be
%   a boolean, a number or a string.
%
%   See also ML.CW.CWI, ML.CW.CWI/text, ML.CW.CWI/select, ML.CW.CWI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.input');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.desc = @ischar;
in.value('') = @(x) ischar(x) || isnumeric(x) || islogical(x);
in = +in;

% --- Check
if isnumeric(in.value)
    in.value = num2str(in.value);
end

% --- Store
this.elms{in.row, in.col} = struct('type', 'input', ...
    'desc', in.desc, ...
    'value', in.value);

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help, added the possibility to remove the
%               description with an empty string.
%   1.0     (2015/04/06): Initial version.
%
%! To do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>